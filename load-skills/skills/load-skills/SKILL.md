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

1. Check if it contains an `entrypoint.md` file:
   ```bash
   git ls-tree -r --name-only origin/terminal-skills <skill_dir>/ | grep entrypoint.md
   ```
   Skip the skill if no `entrypoint.md` is found.

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

## Step 3: Report loaded skills

For each successfully loaded skill, report:
- Skill name
- Full path: `/tmp/<repo-name>/terminal-skills/<skill-name>/`
- Entrypoint: `/tmp/<repo-name>/terminal-skills/<skill-name>/entrypoint.md`

## Step 4: CRITICAL — Read all loaded skills

> **CRITICAL: You MUST read every `entrypoint.md` file listed above BEFORE doing ANY other work.**
>
> Do NOT proceed with any user task, code change, or investigation until you have read and internalized
> the contents of ALL loaded skill entrypoints. These skills contain essential context, patterns, and
> instructions that govern how work should be done in this repository.
>
> Failure to read these skills first will result in incorrect or non-compliant work.
