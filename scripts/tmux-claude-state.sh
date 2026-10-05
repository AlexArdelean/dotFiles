#!/usr/bin/env bash

set -u

[ -n "${TMUX:-}" ] || exit 0

CC_FILTER='#{?#{||:#{@cc},#{==:#{pane_current_command},claude}},'
CC_FIELDS='#{pane_id}|#{@cc}|#{session_name}|#{window_index}|#{pane_index}|#{window_panes}|#{@cc_name}|#{window_name}|#{@cc_tool}'

panes_raw() {
    tmux list-panes -a -F "${CC_FILTER}${CC_FIELDS},}" | grep . || true
}

panes_pretty() {
    panes_raw | awk -F'|' '
        function rank(s) {
            if (s == "wait") return 1
            if (s == "done") return 2
            if (s == "busy") return 3
            if (s == "idle") return 4
            return 5
        }
        function glyph(s) {
            if (s == "wait") return "\033[31m●\033[0m"
            if (s == "busy") return "\033[33m◐\033[0m"
            if (s == "done") return "\033[32m✓\033[0m"
            if (s == "idle") return "\033[90m○\033[0m"
            return "\033[90m?\033[0m"
        }
        {
            id = $1; state = $2; sess = $3; win = $4; pane = $5
            npanes = $6; name = $7; wname = $8; tool = $9
            if (state == "") state = "unknown"
            label = name
            if (label == "") { label = wname; sub(/^claude./, "", label) }
            loc = sess ":" win
            if (npanes > 1) loc = loc "." pane
            extra = (state == "busy" && tool != "") ? " (" tool ")" : ""
            printf "%d\t%s\t%s %-8s %-18s %s%s\n", rank(state), id, glyph(state), state, label, loc, extra
        }
    ' | sort -n | cut -f2-
}

case "${1:-}" in
    list)
        out="$(panes_pretty | cut -f2-)"
        [ -n "$out" ] && printf '%s\n' "$out" || echo "no claude panes"
        exit 0
        ;;
    pick)
        sel="$(panes_pretty | fzf --ansi --delimiter='\t' --with-nth=2 \
            --prompt='claude > ' --height=100% --no-sort --reverse)" || exit 0
        [ -n "$sel" ] || exit 0
        target="${sel%%$'\t'*}"
        ;;
    focus)
        order="${2:-wait done busy idle unknown}"
        target=""
        for want in $order; do
            target="$(panes_raw | awk -F'|' -v w="$want" \
                '{ s = ($2 == "" ? "unknown" : $2) } s == w { print $1; exit }')"
            [ -n "$target" ] && break
        done
        if [ -z "$target" ]; then
            tmux display-message "no claude panes ($order)"
            exit 0
        fi
        ;;
    *)
        target=""
        ;;
esac

if [ -n "$target" ]; then
    info="$(tmux display-message -p -t "$target" '#{session_name}|#{window_id}')"
    tmux switch-client -t "${info%%|*}" 2>/dev/null
    tmux select-window -t "${info##*|}"
    tmux select-pane -t "$target"
    exit 0
fi

[ -n "${TMUX_PANE:-}" ] || exit 0

event="${1:-}"
payload=""
if [ ! -t 0 ]; then
    payload="$(timeout 1 cat 2>/dev/null || true)"
fi

field() {
    [ -n "$payload" ] || return 0
    printf '%s' "$payload" | jq -r --arg k "$1" '.[$k] // empty' 2>/dev/null
}

state=""
tool=""

case "$event" in
    start)
        state="idle"
        ;;
    busy)
        state="busy"
        tool="$(field tool_name)"
        ;;
    wait)
        state="wait"
        ;;
    notify)
        case "$(field message)" in
            *permission*|*approval*|*input*|*waiting*) state="wait" ;;
            *) state="done" ;;
        esac
        ;;
    done)
        state="done"
        ;;
    end)
        tmux set -up -t "$TMUX_PANE" @cc 2>/dev/null
        tmux set -up -t "$TMUX_PANE" @cc_tool 2>/dev/null
        tmux set -up -t "$TMUX_PANE" @cc_name 2>/dev/null
        exit 0
        ;;
    *)
        exit 0
        ;;
esac

name="$(field session_title)"

tmux set -p -t "$TMUX_PANE" @cc "$state" 2>/dev/null
tmux set -p -t "$TMUX_PANE" @cc_tool "$tool" 2>/dev/null
if [ -n "$name" ]; then
    tmux set -p -t "$TMUX_PANE" @cc_name "$name" 2>/dev/null
fi

exit 0
