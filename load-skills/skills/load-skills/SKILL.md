---
name: load-skills
description: Load skills from origin/terminal-skills branch into a local cache and enforce reading them before any work
disable-model-invocation: true
allowed-tools: Bash, Read
---

Run this single command to load skills:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/load.sh"
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
