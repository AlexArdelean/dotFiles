#!/usr/bin/env bash
# fzf popup over the omp sessions board (~/tools/omp-sessions, must be running).

set -u

SELF="$(readlink -f "$0")"
API="http://127.0.0.1:${OMP_SESSIONS_PORT:-8820}/api/sessions"
CACHE="${XDG_RUNTIME_DIR:-/tmp}/tmux-omp-picker.json"
REFRESH=2

# Rows are "paneId<TAB>display", grouped and ordered like the board's sections.
LIST_JQ='
def ago($ms): ($ms / 1000 | floor) as $s
  | if $s < 60 then "\($s)s" elif $s < 3600 then "\($s / 60 | floor)m"
    elif $s < 86400 then "\($s / 3600 | floor)h" else "\($s / 86400 | floor)d" end;
def pad($n): if length > $n then .[0:$n - 1] + "…" else . + ((" " * ($n - length)) // "") end;
def line: (. // "") | split("\n") | map(select(test("\\S"))) | (.[0] // "")
  | gsub("[*`#>]"; "") | gsub("^\\s+|\\s+$"; "");
def c($code): "\u001b[\($code)m\(.)\u001b[0m";

.now as $now
| [.sessions[] | select(.pane != null)] as $all
| ($all | group_by(.pane.sessionName) | map({key: .[0].pane.sessionName, value: length}) | from_entries) as $per
| $all[]
| (.phaseSince // .lastActivity) as $since
| (if .phase == "waiting" then {rank: 0, key: -$since, label: "question", color: "31", detail: (.intent // "Waiting for your answer"), at: $since}
   elif .unread then {rank: 1, key: -$since, label: "reply", color: "32", detail: (.lastAssistant | line), at: $since}
   elif .phase == "working" or .phase == "compacting" then
     {rank: 2, key: $since, label: .phase, color: "33",
      detail: (.intent // (if .tool then "Running \(.tool)" else "Thinking" end)), at: $since}
   elif .typedAt != null and $now - .typedAt < 8 * 3600000 then
     {rank: 3, key: -.typedAt, label: "recent", color: "34", detail: (.lastAssistant | line), at: .typedAt}
   else {rank: 4, key: -$since, label: "idle", color: "90", detail: "", at: .lastActivity} end) as $k
| (.pane.sessionName | gsub("^\\s+|\\s+$"; "")) as $tname
| (if $per[.pane.sessionName] > 1 then "\($tname) · \(.pane.target[(.pane.sessionName | length) + 1:])" else $tname end) as $name
| {rank: $k.rank, key: $k.key,
   row: "\(.pane.paneId)\t\("●" | c($k.color)) \($k.label | pad(10) | c($k.color)) \(ago($now - $k.at) | pad(4) | c("90")) \($name | pad(34) | c("1")) \((.repo // "") | pad(20) | c("36")) \($k.detail)\(if .pane.paneId == $here then " ← here" | c("90") else "" end)"}
' 

PREVIEW_JQ='
.sessions[] | select(.pane.paneId == $pane)
| "\u001b[1m\(.title)\u001b[0m",
  "\(.cwd)\(if .branch then "  (\(.branch))" else "" end)",
  "\(.phase)\(if .tool then " · \(.tool)" else "" end)\(if .intent then " · \(.intent)" else "" end)",
  (.lastUser // empty | "", "\u001b[36mYou:\u001b[0m \(.)"),
  (.lastAssistant // empty | "", "\u001b[33momp:\u001b[0m \(.)")
'

list() {
    local json
    json="$(curl -sf --max-time 3 "$API")" || return 1
    printf '%s' "$json" >"$CACHE"
    printf '%s' "$json" | jq -r --arg here "${1:-}" "[$LIST_JQ] | sort_by(.rank, .key) | .[].row"
}

case "${1:-}" in
    list)
        list "${2:-}"
        ;;
    preview)
        jq -r --arg pane "${2:-}" "$PREVIEW_JQ" "$CACHE"
        ;;
    # Reloads the open picker every REFRESH seconds; stops once fzf exits and its port closes.
    tick)
        while sleep "$REFRESH"; do
            curl -sf -XPOST "localhost:$2" -d "reload-sync($SELF list '$3')+refresh-preview" >/dev/null || exit 0
        done
        ;;
    # Closes the session's pane after a y/N prompt. The pane you opened the picker from is refused:
    # if it were the last one in its tmux session, the client would detach. Talks to /dev/tty because
    # fzf hands its own stdout (the picker's result pipe) to execute().
    kill)
        pane="${2:-}"
        [ -n "$pane" ] || exit 0
        if [ "$pane" = "${3:-}" ]; then
            printf "That's the pane you're in; close it from there.\n" >/dev/tty
            sleep 1.5
            exit 0
        fi
        name="$(jq -r --arg pane "$pane" '.sessions[] | select(.pane.paneId == $pane) | "\(.pane.target)  \(.title)"' "$CACHE")"
        printf '\n  Kill %s? [y/N] ' "${name:-$pane}" >/dev/tty
        read -rsn1 answer </dev/tty
        [[ "$answer" == [yY] ]] && tmux kill-pane -t "$pane"
        ;;
    pick)
        here="${2:-}"
        client=(${3:+-c "$3"})
        rows="$(list "$here")" || {
            tmux display-message "${client[@]}" "omp sessions board isn't reachable at $API"
            exit 0
        }
        sel="$(printf '%s\n' "$rows" | fzf --ansi --delimiter='\t' --with-nth=2 \
            --no-sort --track --reverse --prompt='omp > ' --info=inline \
            --header="enter: jump · ctrl-x: kill · refreshes every ${REFRESH}s" \
            --preview "$SELF preview {1}" --preview-window='down,45%,wrap' \
            --bind "ctrl-x:execute($SELF kill {1} '$here')+reload-sync($SELF list '$here')" \
            --listen --bind "start:execute-silent:$SELF tick \$FZF_PORT '$here' >/dev/null 2>&1 &")" || exit 0
        pane="${sel%%$'\t'*}"
        [ -n "$pane" ] || exit 0
        tmux switch-client "${client[@]}" -t "$pane" 2>/dev/null
        tmux select-window -t "$pane"
        tmux select-pane -t "$pane"
        ;;
    *)
        echo "usage: $0 pick [pane [client]] | list [pane] | preview <pane> | tick <port> [pane] | kill <pane> [here]" >&2
        exit 2
        ;;
esac
