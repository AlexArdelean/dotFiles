#!/usr/bin/env bash

set -u

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim-memlog"
LOG_FILE="$LOG_DIR/memlog.csv"

proc_name() {
    local args="$1" word
    # node/java servers are only identifiable by their script argument
    for word in $args; do
        case "$word" in
            *.js|*.cjs|*.mjs|*-language-server|*tsserver*|*.jar) basename "$word"; return ;;
        esac
    done
    basename "${args%% *}"
}

sample() {
    mkdir -p "$LOG_DIR"
    [ -f "$LOG_FILE" ] || echo "ts,nvim_pid,pid,uptime_s,rss_kb,name,nvim_cwd" > "$LOG_FILE"

    local ts table nvim_pid cwd
    ts=$(date +%s)
    table=$(ps -eo pid=,ppid=,etimes=,rss=,args=)

    for nvim_pid in $(pgrep -x nvim); do
        [ "$(cat "/proc/$(awk '{print $4}' "/proc/$nvim_pid/stat")/comm" 2>/dev/null)" = nvim ] && continue
        cwd=$(readlink "/proc/$nvim_pid/cwd" 2>/dev/null || echo "?")
        echo "$table" | awk -v root="$nvim_pid" '
            { pid[NR] = $1; ppid[NR] = $2; line[NR] = $0 }
            END {
                tree[root] = 1
                do {
                    added = 0
                    for (i = 1; i <= NR; i++)
                        if ((ppid[i] in tree) && !(pid[i] in tree)) { tree[pid[i]] = 1; added = 1 }
                } while (added)
                for (i = 1; i <= NR; i++) if (pid[i] in tree) print line[i]
            }' | while read -r pid _ etimes rss args; do
            printf '%s,%s,%s,%s,%s,%s,%s\n' "$ts" "$nvim_pid" "$pid" "$etimes" "$rss" \
                "$(proc_name "$args")" "$cwd" >> "$LOG_FILE"
        done
    done
}

report() {
    [ -f "$LOG_FILE" ] || { echo "no data yet: $LOG_FILE"; exit 1; }
    awk -F, 'NR > 1 {
            key = $2 "," $3
            if (!(key in first_ts)) { first_ts[key] = $1; first_rss[key] = $5 }
            last_ts[key] = $1; last_rss[key] = $5; up[key] = $4
            name[key] = $6; cwd[key] = $7
        }
        END {
            for (k in last_ts) {
                hours = (last_ts[k] - first_ts[k]) / 3600
                rate = hours > 0 ? (last_rss[k] - first_rss[k]) / 1024 / hours : 0
                split(k, ids, ",")
                printf "%8.0f %+9.0f %+9.1f %7.1f  %-7s %-7s %-32s %s\n", last_rss[k] / 1024,
                    (last_rss[k] - first_rss[k]) / 1024, rate, up[k] / 3600, ids[1], ids[2], name[k], cwd[k]
            }
        }' "$LOG_FILE" | sort -k1,1nr | {
        printf "%8s %9s %9s %7s  %-7s %-7s %-32s %s\n" RSS_MB GROWN_MB MB/HOUR UP_H NVIM PID NAME CWD
        cat
    }
}

case "${1:-sample}" in
    sample) sample ;;
    report) report ;;
    *) echo "usage: $0 [sample|report]" >&2; exit 2 ;;
esac
