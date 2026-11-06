---
name: infra-change
description: Use whenever the user asks for a change in ~/infrastructure (the LuminousRobotics Terraform repo) - a new table, IAM grant, app/platform resource, etc. Runs the whole workflow end to end without stopping for confirmation - branch, edit, plan, PR, CI, merge, apply, verify, clean up - and stops only at the hard stops listed in the skill.
---

The user describes the change; you carry it all the way to "applied and verified". They have
pre-authorized branching, pushing, opening PRs, merging their own PRs, and applying -- don't ask
for confirmation at each step. Do ask at a **hard stop** (below).

Before editing code or committing, follow the `code-comments` and `git-commit` skills (commits
are the user's own, with no AI attribution in commits or PR bodies).

## Which root applies how

Read `docs/ci.md` and `docs/platform.md` if anything here looks stale.

| root | applied by |
|---|---|
| `.` (root, workspace `dev`), `s3/` | CI, on every push to `main` (`TF_CI_APPLY_ENABLED=true`). **Merging is the apply.** |
| `platform/`, `apps/*` | CI, on push to `main`, when the root (or a `modules/<name>/` it uses) changed since the last fully successful push run; apps after `platform/`. **Merging is the apply**, an app root's first apply included: the registry entry in `platform/` merges first, in its own PR, then the app root's PR; DNS/secrets/first deploy follow per `docs/platform.md`. |
| `iam/`, `backend/`, `oidc-provider/` | By hand, admin only. Hard stop before applying (see below). `iam/` is not planned by CI at all. |

For every CI-applied root: never hand-apply from a branch. CI refuses any plan that deletes or
replaces something (except an ECS task definition), and refuses a commit `main` has moved past;
a refused or failed root is applied by hand from an up-to-date `origin/main` (hard stop for a
delete/replace, see below). Only re-run the newest push run, never an older one.

## Workflow

1. **Plan the PRs.** Work out which roots the change touches and in what order. A change that
   creates something in one root and reads it via a data source in another (e.g. a registry
   table in `variables.tf` that `apps/fleet/data.tf` reads) needs **separate PRs**: the second
   one's plan fails until the first is applied. Do them in sequence, each fully applied before
   the next starts.
2. **Branch** in a worktree off a fresh `origin/main`, so the user's checkout is untouched:
   `git fetch origin && git worktree add --no-track -b <type>/<short-name> .claude/worktrees/<short-name> origin/main`.
   Short names, no ticket key (`feature/customer-sites-table`, `fix/remove-old-fleet`).
3. **Edit**, copying the surrounding style. Prefer the existing registries/lists (e.g. the
   `dynamodb_tables` registry, `local.backend_tables`) over new resources or IAM statements;
   check module defaults before setting fields explicitly.
4. **Check** in each touched root: `terraform init` if needed, `terraform fmt -check` (on the
   files you touched -- unrelated files may already be unformatted), `terraform validate`,
   `terraform plan -lock=false` (root uses workspace `dev`). Read the whole plan: it must contain
   exactly the intended changes and nothing else.
5. **Commit, push, open the PR.** The body says what changes, the plan summary
   (`N to add, N to change, N to destroy` plus the notable resources/ARNs), and any follow-up PR
   that depends on this one.
6. **Security review** of the full diff (`git diff origin/main...<branch>`) -- see "Security
   review" below. Do this for your own PRs and, especially, for PRs someone else wrote.
7. **Wait for CI**: `gh pr checks <n> --watch`. Every check must pass. Compare CI's plan comment
   for the touched root with your local plan.
8. **Merge**: `gh pr merge <n> --merge --admin` (the user is an org owner, allowed to merge their
   own PRs; the repo uses merge commits). Never merge with a failing or pending check. For a PR
   someone else wrote that the user asked to ship: once the security review is clean, approve
   it (`gh pr review <n> --approve`) and merge without `--admin`. If the branch is behind
   `main`, plan it against current `main` before merging, not just the PR's old CI plan.
9. **Apply.**
   - CI-applied roots: find the push run (`gh run list --workflow terraform.yml --branch main --event push`),
     `gh run watch <id> --exit-status`, and confirm the `apply (...)` job for each touched root
     succeeded (`apply (app-<name>)`, `apply (platform)`), not just `apply (root)`.
   - Hand-applied roots (`iam/`, `backend/`, `oidc-provider/`, or a root CI refused): from a
     detached `origin/main` checkout of the merge commit, `terraform plan -out=<scratchpad>/<root>.tfplan`,
     confirm it matches the PR's plan, then `terraform apply <that file>`. Never apply without a
     saved, reviewed plan file.
10. **Verify**: re-run `terraform plan` in each applied root and expect "No changes". Optionally
    read the resource back through the AWS MCP `run_script` tool (boto3) -- the `aws` CLI exits
    120 on this machine.
11. **Clean up**: `git worktree remove`, delete the local branches. Leave the user's main
     checkout on `main`.
12. **Report** briefly: PR links, each plan summary, apply result, verification, and anything
    left for the user (e.g. an app branch that may now merge).

## Security review

Read every changed line (not just the plan summary) and check:

- **IAM and resource policies**: wildcard actions or resources (`*`, `dynamodb:*`, `iam:*`,
  `sts:AssumeRole` on `*`), new trust relationships, `Principal = "*"` or a service principal
  without an `aws:SourceAccount`/`aws:SourceArn` condition, cross-account access, any path to
  privilege escalation (`iam:PassRole`, `iam:Put*Policy`, `iam:CreateAccessKey`, editing the CI
  roles in `oidc-provider/`).
- **Exposure**: security groups open to `0.0.0.0/0` or `::/0` beyond the ALB's 80/443, public S3
  buckets/ACLs or disabled public-access blocks, public subnets/IPs, new listeners, CORS `*`.
- **Secrets**: plaintext secrets, tokens or keys in `.tf`, `.tfvars`, defaults or outputs;
  sensitive values in outputs without `sensitive = true`; secret values that end up in state,
  logs, alarm descriptions or notification bodies.
- **Data protection**: encryption at rest turned off or weakened, PITR, deletion protection or
  `prevent_destroy` removed from anything holding data, retention or TTL shortened.
- **Detection and audit**: CloudTrail, alarms, guard rails (`guard.tf`) or logging disabled or
  narrowed; allowlists or exclusions in alerting that an attacker could fall inside (e.g. a
  deploy role excluded from a "changed outside deploy" alert).
- **Supply chain**: new or bumped providers/modules from unpinned or unfamiliar sources,
  GitHub Actions not pinned, workflows given broader `permissions:`.
- **Manual steps** the PR asks for (console clicks, group settings, CLI commands): do they
  widen access outside Terraform?

Classify each finding as **blocking** (a real exposure or privilege grant beyond what the change
needs: hard stop, report it and don't merge) or **non-blocking** (hardening ideas, accepted
trade-offs: carry on, and list them in the final report). For a PR someone else wrote, post
blocking findings as a PR review comment only after the user agrees.

## Hard stops -- ask the user before continuing

- The plan has any **destroy or replace**, or any change you didn't intend (drift, another
  person's unapplied change, provider upgrades).
- Applying `iam/`, `backend/` or `oidc-provider/`.
- A **blocking** security finding.
- A CI check fails, CI's plan differs from yours, or a CI apply fails (diagnose and report;
  re-applying by hand is from `main` only).
- The post-merge plan for a hand-applied root differs from the PR's plan.
- The change needs something Terraform can't do (deleting a non-empty ECR repo, setting a
  secret value, DNS outside AWS) -- say what and why.
- A downstream app deploy depends on this change (e.g. a `lumi_fleet_management` branch whose
  merge deploys to production): finish the infra side, then tell the user it's safe to merge
  the app; don't merge app repos yourself.
