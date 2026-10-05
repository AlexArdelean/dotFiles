# Online-first host completion for ssh over Tailscale.
#
#   ssh lumi-<TAB>        -> only devices currently online
#   sshall lumi-<TAB>     -> every device, online or not
#
# If nothing online matches the prefix, ssh completion falls back to the full
# list rather than dead-ending. Note that a repeat-TAB "widen" cannot work
# here: with show-all-if-ambiguous off, bash needs the second TAB to display
# an ambiguous list, so a function keying off it would eat that press.
# Sourced from ~/dotFiles/bashrc.

# Ensure the stock ssh completion exists so we can delegate to it for
# options and remote-command arguments. Must be sourced BEFORE we register
# ours, since it re-registers `complete -F _ssh ssh` itself.
if ! declare -F _ssh >/dev/null 2>&1 && ! declare -F _comp_cmd_ssh >/dev/null 2>&1; then
  for _f in /usr/share/bash-completion/completions/ssh; do
    [ -r "$_f" ] && . "$_f"
  done
  unset _f
fi

_ts_stock_ssh_completion() {
  if declare -F _comp_cmd_ssh >/dev/null 2>&1; then _comp_cmd_ssh
  elif declare -F _ssh >/dev/null 2>&1; then _ssh
  fi
}

# List tailnet device short-names. $1 = "online" (default) or "all".
# Self is forced online -- the local machine is always reachable, and the
# Online field on Self is observed to flap.
_ts_hosts() {
  local sel='map(select(.Online == true))'
  [ "$1" = all ] && sel='.'
  tailscale status --json 2>/dev/null | jq -r "
    ([.Self + {Online: true}] + (.Peer // {} | to_entries | map(.value)))
    | map(select(.OS != \"iOS\" and .OS != \"android\"))
    | $sel
    | map(.DNSName | split(\".\")[0])
    | sort | .[]
  " 2>/dev/null
}

# Hosts defined by hand in ~/.ssh/config (e.g. the LAN `lumi` entry).
# config.d/ is skipped: it is generated from the tailnet and already covered.
_ts_config_hosts() {
  [ -r "$HOME/.ssh/config" ] || return 0
  awk 'tolower($1) == "host" {
         for (i = 2; i <= NF; i++) if ($i !~ /[*?!]/) print $i
       }' "$HOME/.ssh/config"
}

_ssh_online_complete() {
  local cur cword words
  if declare -F _init_completion >/dev/null 2>&1; then
    _init_completion -n : || return
  else
    cur="${COMP_WORDS[COMP_CWORD]}"; cword=$COMP_CWORD; words=("${COMP_WORDS[@]}")
  fi

  # Options and their arguments: hand back to the stock completion.
  if [[ $cur == -* ]]; then
    _ts_stock_ssh_completion
    return
  fi

  # If a hostname was already supplied, we are completing a remote command.
  local i seen_host=0
  for (( i = 1; i < cword; i++ )); do
    [[ ${words[i]} == -* ]] && continue
    [[ ${words[i-1]} == -@(b|c|D|E|e|F|I|i|J|L|l|m|O|o|p|Q|R|S|W|w) ]] && continue
    seen_host=1
  done
  if (( seen_host )); then
    _ts_stock_ssh_completion
    return
  fi

  local userpart="" hostpart="$cur"
  if [[ $cur == *@* ]]; then
    userpart="${cur%@*}@"
    hostpart="${cur##*@}"
  fi

  # $_ts_scope is set to "all" by the sshall wrapper's completion.
  local scope="${_ts_scope:-online}"

  local matches
  matches=$(compgen -W "$(_ts_hosts "$scope"; _ts_config_hosts)" -- "$hostpart")
  # Nothing online matched -- fall back to the full list rather than dead-end.
  [[ -z $matches && $scope == online ]] && \
    matches=$(compgen -W "$(_ts_hosts all; _ts_config_hosts)" -- "$hostpart")
  # Still nothing: it is not a tailnet name, so use ssh_config/known_hosts.
  if [[ -z $matches ]]; then
    _ts_stock_ssh_completion
    return
  fi

  COMPREPLY=()
  local h
  while IFS= read -r h; do
    [ -n "$h" ] && COMPREPLY+=( "$userpart$h" )
  done <<< "$matches"
  declare -F __ltrim_colon_completions >/dev/null 2>&1 && \
    __ltrim_colon_completions "$cur"
}

complete -F _ssh_online_complete ssh

# Deliberate connection to a host that may be offline, with completion over
# the whole tailnet.
sshall() { ssh "$@"; }
_sshall_complete() { local _ts_scope=all; _ssh_online_complete; }
complete -F _sshall_complete sshall

# List every tailnet device with its current state.
ts-hosts() {
  tailscale status --json | jq -r '
    ([.Self + {Online: true}] + (.Peer // {} | to_entries | map(.value)))
    | map(select(.OS != "iOS" and .OS != "android"))
    | sort_by((.Online | not), (.DNSName | ascii_downcase))
    | .[]
    | [ (if .Online then "online " else "offline" end),
        (.DNSName | split(".")[0]),
        .OS,
        (.TailscaleIPs[0] // "-") ]
    | @tsv' | column -t
}
