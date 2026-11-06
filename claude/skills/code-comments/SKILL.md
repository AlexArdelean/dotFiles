---
name: code-comments
description: Whenever Claude writes or edits code in any repository, only add comments that are necessary and that match the commenting style already used in that repo. Check this before adding any comment, docstring, or JSDoc.
---

Comments must earn their place and must look like the surrounding code's comments. When in doubt, leave it out.

## 1. Learn the repo's style first

Before adding a comment in a file, look at how comments are already written — first in that file, then in neighbouring files in the same directory/package. Note:

- **Density** — how often does the code comment at all? If a file has almost no comments, yours should be rare too.
- **Syntax** — `//` vs `/* */`, `#`, docstring format (Google / NumPy / reST / JSDoc / TSDoc / Doxygen), or none.
- **Placement** — above the line vs trailing, on every function vs only on public APIs.
- **Voice** — capitalisation, punctuation, full sentences vs fragments, tense.
- **Markers** — whether the repo uses `TODO`, `FIXME`, `NOTE`, and in what format (e.g. `TODO(name):`, ticket IDs).

Match what you find. Do not introduce a new docstring convention, section-divider banners, or a heavier comment density than the file already has. If there are no comments anywhere nearby, default to adding none.

## 2. Only add a comment if it's necessary

A comment is necessary only when it tells the reader something the code can't:

- **Why** something is done a non-obvious way (a workaround, a constraint, a hardware/protocol quirk, a performance reason).
- **Hidden invariants or gotchas** — ordering requirements, units, thread-safety, side effects that aren't visible from the signature.
- **References** — a link to an issue, spec, or datasheet that justifies the code.
- **Public API docs** — only where the repo already documents its public APIs that way.

Do NOT add comments that:

- Restate what the code does (`// increment counter`, `# loop over items`, `// return the result`).
- Narrate the change or your process (`// added this to fix the bug`, `// new helper`, `// updated per request`, `// changed from X to Y`). That belongs in the commit message, not the code.
- Label obvious sections (`// imports`, `// state`, `// handlers`) unless the file already does this.
- Duplicate the function/variable name as a docstring (`/** Gets the user. */ getUser()`).
- Leave commented-out code behind.
- Add `TODO`s for things you could just do now, or that the user didn't ask for.

Prefer clearer names or a small extraction over a comment explaining confusing code.

## 3. Existing comments

- Don't delete or rewrite existing comments that are unrelated to your change.
- If your change makes an existing comment wrong, update it (or remove it if it's no longer needed) — stale comments are worse than none.

## Quick check before finishing

For every comment you added, ask: *Would a maintainer of this repo have written this, in this form?* and *Would the code be harder to understand without it?* If either answer is no, remove it.
