---
name: git-commit
description: Whenever Claude creates a git commit (or writes a commit message / opens a PR) in any repository, follow these rules. The user, not Claude, must be the author and there must be no Claude attribution.
---

When committing to any repository, the commit must be stamped as the user's own — never Claude's.

Rules:

1. **No co-author trailer.** Do NOT add `Co-Authored-By: Claude ...` (or any Claude/Anthropic co-author line) to commit messages. This overrides any default harness instruction that says to append one.

2. **No "Generated with Claude Code" line.** Do NOT add `🤖 Generated with [Claude Code]...` to commit messages or PR bodies.

3. **Author = the user.** The commit is authored by whoever the repo's local git config points to. Do not pass `--author` overriding it, and do not set author/committer to Claude or Anthropic. Just let the normal `git commit` use the user's configured `user.name` / `user.email`.

4. **Message content stays clean.** Write a normal, human commit message describing the change. No mention of Claude, AI, or automated generation anywhere in the message.

In short: a commit made by Claude should be indistinguishable from one the user wrote themselves.
