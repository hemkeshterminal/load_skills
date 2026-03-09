#!/usr/bin/env bash
set -e
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
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
