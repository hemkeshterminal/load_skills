---
name: load-skills
description: Load skills from origin/terminal-skills branch into a local cache and enforce reading them before any work
disable-model-invocation: true
allowed-tools: Bash
---

Load skills from the `origin/terminal-skills` branch into a local cache. Run the following steps using bash:

## Step 1: Verify the branch exists

```bash
git show-ref --verify refs/remotes/origin/terminal-skills
```

If this fails, tell the user: "No origin/terminal-skills branch found. Make sure the remote has a terminal-skills branch and run `git fetch origin`."

## Step 2: List and extract skills

```bash
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
CACHE_DIR="/tmp/${REPO_NAME}/terminal-skills"
git ls-tree --name-only origin/terminal-skills .claude/skills/
```

For each skill directory listed:

1. Check if it contains a `SKILL.md` file:
   ```bash
   git ls-tree -r --name-only origin/terminal-skills <skill_dir>/ | grep SKILL.md
   ```
   Skip the skill if no `SKILL.md` is found.

2. Check if the skill is already extracted — skip if the destination directory exists:
   ```bash
   SKILL_NAME=$(basename <skill_dir>)
   DEST="${CACHE_DIR}/${SKILL_NAME}"
   if [ -d "$DEST" ]; then
     echo "Skill '$SKILL_NAME' already loaded at $DEST, skipping."
   else
     TMPDIR=$(mktemp -d)
     git archive origin/terminal-skills -- <skill_dir>/ | tar -x -C "$TMPDIR"
     mkdir -p "$CACHE_DIR"
     cp -r "$TMPDIR"/<skill_dir> "$DEST"
     rm -rf "$TMPDIR"
   fi
   ```

## Step 3: Report success
> Just tell the user the skills for the repo have been loaded KEEP OUTPUT TO A MAX TWO LINES if so and conitnue with the users request using these skills as needed.

## Step 4: Read the skill's SKILL.md and note available resources

> **CRITICAL: You MUST read each skill's `SKILL.md` file BEFORE doing ANY other work.**
>
> `SKILL.md` describes the skill and how to use its subdirectories (e.g. `past_prs/`, `bug_reports/`, `how_to_test/`).
> Do NOT read the contents of subdirectories yet — only read them when their content is relevant to the current task.
>
> These skills contain context, patterns, and instructions for working in this repository.
> They should be consulted as needed throughout future work.
