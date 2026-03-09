---
name: load-skills
description: Load skills from origin/terminal-skills branch into a local cache and enforce reading them before any work
disable-model-invocation: true
allowed-tools: Bash, Read
---

Run this single script to load skills. Do NOT split it into multiple commands:

```bash
set -e
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
CACHE_DIR="/tmp/${REPO_NAME}/terminal-skills"
BRANCH="origin/terminal-skills"

if ! git show-ref --verify "refs/remotes/${BRANCH}" >/dev/null 2>&1; then
  echo "ERROR: No ${BRANCH} branch found. Run: git fetch origin"
  exit 1
fi

LOADED=""
for SKILL_DIR in $(git ls-tree --name-only "$BRANCH" .claude/skills/); do
  git ls-tree -r --name-only "$BRANCH" "${SKILL_DIR}/" | grep -q SKILL.md || continue
  SKILL_NAME=$(basename "$SKILL_DIR")
  DEST="${CACHE_DIR}/${SKILL_NAME}"
  if [ -d "$DEST" ]; then
    LOADED="${LOADED}${SKILL_NAME} (cached) "
  else
    TMPDIR=$(mktemp -d)
    git archive "$BRANCH" -- "${SKILL_DIR}/" | tar -x -C "$TMPDIR"
    mkdir -p "$CACHE_DIR"
    cp -r "$TMPDIR/${SKILL_DIR}" "$DEST"
    rm -rf "$TMPDIR"
    LOADED="${LOADED}${SKILL_NAME} (extracted) "
  fi
done

echo "Skills loaded to ${CACHE_DIR}: ${LOADED}"
ls -1 "${CACHE_DIR}/" 2>/dev/null | head -20
```

After the script completes:

> **CRITICAL: You MUST read the first 10% of lines from each skill's `SKILL.md` BEFORE doing ANY other work.**
>
> Path: `/tmp/<repo-name>/terminal-skills/<skill-name>/SKILL.md`
>
> `SKILL.md` describes the skill and how to use its subdirectories.
> Do NOT read the contents of subdirectories yet — only read them when their content is relevant to the current task.
>
> These skills contain context, patterns, and instructions for working in this repository.
> They should be consulted as needed throughout future work.
> For complex tasks add a todo to search the skills for relevant information.
