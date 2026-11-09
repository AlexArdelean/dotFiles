#!/usr/bin/env python3
"""Text search inside omp conversations, for tmux-omp-picker.sh's ctrl-f mode.

  index                       bring every live session's text index up to date
  rows <here> <query…>        picker rows for sessions whose conversation has every word
  preview <pane> <query…>     that session's matching lines, words highlighted

Each session's transcript (~/.omp/agent/sessions/*/*_<id>.jsonl) is reduced to one line per piece
of text (your messages, omp's replies and thinking, tool calls, tool output) in
~/.cache/omp-picker-index/<id>.txt. Only bytes appended since the last run are read, so a busy
session costs little per keystroke.
"""
import fcntl
import glob
import json
import os
import re
import sys

CACHE = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "tmux-omp-picker.json")
SESSIONS = os.path.expanduser("~/.omp/agent/sessions")
INDEX = os.path.expanduser("~/.cache/omp-picker-index")
PIECE_MAX = 4000


def live_sessions():
    try:
        with open(CACHE) as f:
            return [s for s in json.load(f)["sessions"] if s.get("pane")]
    except (OSError, ValueError, KeyError):
        return []


def transcript(session_id):
    found = glob.glob(os.path.join(SESSIONS, "*", f"*_{session_id}.jsonl"))
    return found[0] if found else None


def pieces(entry):
    if entry.get("type") != "message":
        return
    m = entry.get("message") or {}
    role = m.get("role")
    who = {"user": "you", "assistant": "omp", "toolResult": "tool"}.get(role, role or "?")
    content = m.get("content")
    if isinstance(content, str):
        yield who, content
        return
    for b in content or []:
        if not isinstance(b, dict):
            continue
        kind = b.get("type")
        if kind == "text":
            yield who, b.get("text", "")
        elif kind == "thinking":
            yield "thinking", b.get("thinking", "")
        elif kind == "toolCall":
            yield f"call {b.get('name', '')}", json.dumps(b.get("arguments", {}), ensure_ascii=False)


def update(session_id, path):
    """Append text from the transcript's new complete lines to the index; returns the index path."""
    os.makedirs(INDEX, exist_ok=True)
    txt = os.path.join(INDEX, f"{session_id}.txt")
    with open(os.path.join(INDEX, f"{session_id}.off"), "a+") as off:
        fcntl.flock(off, fcntl.LOCK_EX)
        off.seek(0)
        done = int(off.read() or 0)
        size = os.path.getsize(path)
        if size < done:  # rewritten, not appended to: start over
            done = 0
            open(txt, "w").close()
        if size == done:
            return txt
        with open(path, "rb") as src:
            src.seek(done)
            chunk = src.read(size - done)
        end = chunk.rfind(b"\n") + 1
        lines = []
        for raw in chunk[:end].splitlines():
            try:
                entry = json.loads(raw)
            except ValueError:
                continue
            for who, text in pieces(entry):
                flat = " ".join(text.split())
                if flat:
                    lines.append(f"{who}: {flat[:PIECE_MAX]}\n")
        with open(txt, "a") as out:
            out.writelines(lines)
        off.seek(0)
        off.truncate()
        off.write(str(done + end))
    return txt


def matches(session, words):
    path = transcript(session["sessionId"])
    if path is None:
        return []
    with open(update(session["sessionId"], path)) as f:
        return [line.rstrip("\n") for line in f if all(w in line.lower() for w in words)]


def snippet(line, word, width=120):
    i = line.lower().find(word)
    start = max(0, i - 40)
    text = line[start : start + width]
    return ("…" if start > 0 else "") + text + ("…" if start + width < len(line) else "")


def color(code, text):
    return f"\033[{code}m{text}\033[0m"


def pad(text, n):
    return text[: n - 1] + "…" if len(text) > n else text.ljust(n)


def rows(here, query):
    words = query.lower().split()
    if not words or len(query.strip()) < 2:
        print("\tType at least 2 characters to search inside conversations")
        return
    sessions = live_sessions()
    per = {}
    for s in sessions:
        per[s["pane"]["sessionName"]] = per.get(s["pane"]["sessionName"], 0) + 1
    found = []
    for s in sessions:
        hits = matches(s, words)
        if hits:
            found.append((len(hits), s, hits[-1]))
    if not found:
        print(f"\tNo conversation mentions {query.strip()!r}")
        return
    for count, s, last in sorted(found, key=lambda f: (-f[0], -f[1]["lastActivity"])):
        pane = s["pane"]
        name = pane["sessionName"].strip()
        if per[pane["sessionName"]] > 1:
            name += " · " + pane["target"][len(pane["sessionName"]) + 1 :]
        here_mark = color("90", " ← here") if pane["paneId"] == here else ""
        print(
            f"{pane['paneId']}\t{color('35', pad(f'{count}×', 6))} {color('1', pad(name, 34))} "
            f"{color('36', pad(s.get('repo') or '', 20))} {snippet(last, words[0])}{here_mark}"
        )


def preview(pane_id, query):
    words = query.lower().split()
    session = next((s for s in live_sessions() if s["pane"]["paneId"] == pane_id), None)
    if session is None or not words:
        return
    hits = matches(session, words)
    print(color("1", session["title"]), f"· {len(hits)} matching lines, newest last\n")
    pattern = re.compile("|".join(re.escape(w) for w in words), re.IGNORECASE)
    for line in hits[-30:]:
        text = line if len(line) <= 400 else snippet(line, words[0], 400)
        print(pattern.sub(lambda m: color("1;33", m.group(0)), text), "\n")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "index":
        for s in live_sessions():
            path = transcript(s["sessionId"])
            if path:
                update(s["sessionId"], path)
    elif cmd == "rows":
        rows(sys.argv[2], " ".join(sys.argv[3:]))
    elif cmd == "preview":
        preview(sys.argv[2], " ".join(sys.argv[3:]))
    else:
        sys.exit(f"usage: {sys.argv[0]} index | rows <here> <query…> | preview <pane> <query…>")


if __name__ == "__main__":
    main()
