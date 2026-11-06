#!/usr/bin/env bash
# tmux-resurrect post-save-layout hook: rewrites each omp pane's saved command to
# `omp --resume <session file>`, so a restore (after a reboot) reopens that exact conversation.
# The saved command is otherwise whatever omp was started with, often a bare `omp` that would
# start a new session. Restored because tmux.conf lists `omp` in @resurrect-processes.

set -u

SAVE_FILE="${1:?usage: tmux-resurrect-omp.sh <resurrect save file>}"
STATE_DIR="$HOME/.omp/run/session-state"
BOARD="http://127.0.0.1:${OMP_SESSIONS_PORT:-8820}/api/sessions"

# The omp process in a pane: the pane's own process after /restart's exec, else its child.
omp_pid() {
    local pane_pid
    pane_pid=$(tmux display-message -p -t "$1" '#{pane_pid}' 2>/dev/null) || return 1
    if [ "$(cat "/proc/$pane_pid/comm" 2>/dev/null)" = omp ]; then
        echo "$pane_pid"
    else
        pgrep -P "$pane_pid" -x omp | head -1
    fi
}

# The session file the pane's omp has open now. In order: what the session-state extension last
# reported (follows /new and /resume inside omp), the --resume argument it was started with, then
# the session board's view of that pane.
session_file() {
    local target="$1" pid file arg id
    pid=$(omp_pid "$target") || return 1
    [ -n "$pid" ] || return 1

    file=$(jq -r '.sessionFile // empty' "$STATE_DIR/$pid.json" 2>/dev/null)
    [ -n "$file" ] && [ -f "$file" ] && { echo "$file"; return 0; }

    arg=$(tr '\0' '\n' <"/proc/$pid/cmdline" 2>/dev/null | awk 'prev ~ /^(--resume|-r|--session)$/ { print; exit } { prev = $0 }')
    if [ -n "$arg" ]; then
        [ -f "$arg" ] && { echo "$arg"; return 0; }
        file=$(ls "$HOME"/.omp/agent/sessions/*/*_"$arg"*.jsonl 2>/dev/null | head -1)
        [ -n "$file" ] && { echo "$file"; return 0; }
    fi

    id=$(curl -fsS --max-time 2 "$BOARD" 2>/dev/null |
        jq -r --arg t "$target" '.sessions[] | select(.pane.target == $t) | .sessionId' | head -1)
    [ -n "$id" ] || return 1
    file=$(ls "$HOME"/.omp/agent/sessions/*/*_"$id".jsonl 2>/dev/null | head -1)
    [ -n "$file" ] && echo "$file"
}

tmp="$SAVE_FILE.omp.$$"
while IFS= read -r line; do
    IFS=$'\t' read -r -a f <<<"$line"
    # pane, session, window, window_active, window_flags, pane_index, title, :dir, pane_active,
    # current_command, :full_command
    if [ "${f[0]}" = pane ] && [ "${f[9]:-}" = omp ]; then
        file=$(session_file "${f[1]}:${f[2]}.${f[5]}")
        if [ -n "$file" ]; then
            f[10]=":omp --resume $(printf '%q' "$file")"
            line=$(IFS=$'\t'; echo "${f[*]}")
        fi
    fi
    printf '%s\n' "$line"
done <"$SAVE_FILE" >"$tmp" && mv "$tmp" "$SAVE_FILE"
