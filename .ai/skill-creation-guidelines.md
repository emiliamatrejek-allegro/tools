# Claude Code Skill Creation Guidelines

## What is a Skill?

A skill is a `SKILL.md` file (with optional supporting files) that extends Claude's capabilities. Skills can be:
- Invoked directly via `/skill-name`
- Auto-invoked by Claude when the context matches the skill's description
- Run inline (in-context) or in an isolated subagent (`context: fork`)

> Skills supersede the older `.claude/commands/` approach. Commands still work, but skills add more features and are preferred.

---

## Where Skills Live (Scope)

| Scope      | Path                                              | Availability             |
|------------|---------------------------------------------------|--------------------------|
| Enterprise | managed settings                                  | All org users            |
| Personal   | `~/.claude/skills/<skill-name>/SKILL.md`          | All your projects        |
| Project    | `.claude/skills/<skill-name>/SKILL.md`            | This project only        |
| Plugin     | `<plugin>/skills/<skill-name>/SKILL.md`           | Where plugin is enabled  |

**Priority:** enterprise > personal > project (when names conflict).  
Plugin skills use `plugin-name:skill-name` namespace — no conflicts possible.

Claude Code also auto-discovers skills from nested `.claude/skills/` directories in subdirectories (useful in monorepos).

---

## Skill Directory Structure

```
my-skill/
├── SKILL.md           # Required — main instructions and frontmatter
├── template.md        # Optional — template for Claude to fill in
├── examples/
│   └── sample.md      # Optional — example output showing expected format
└── scripts/
    └── validate.sh    # Optional — script Claude can execute
```

Keep `SKILL.md` under **500 lines**. Move detailed reference material to separate files and reference them from `SKILL.md`.

---

## SKILL.md Structure

Every skill has two parts:

1. **YAML frontmatter** (between `---` markers) — configures behavior
2. **Markdown content** — instructions Claude follows when the skill is invoked

### Minimal example

```markdown
---
name: explain-code
description: Explains code with visual diagrams. Use when explaining how code works or the user asks "how does this work?"
---

When explaining code, always include:
1. An analogy comparing it to everyday life
2. An ASCII diagram showing flow or structure
3. Step-by-step walkthrough
4. A common gotcha or misconception
```

---

## Frontmatter Reference

All fields are optional; `description` is strongly recommended.

| Field                    | Required | Notes |
|--------------------------|----------|-------|
| `name`                   | No       | Slash-command name. Lowercase, numbers, hyphens only, max 64 chars. Defaults to directory name. |
| `description`            | Recommended | What it does and when to use it. Claude uses this to auto-invoke. |
| `argument-hint`          | No       | Hint shown in autocomplete, e.g. `[issue-number]` |
| `disable-model-invocation` | No    | `true` = only you can invoke; Claude never auto-invokes. Default: `false`. |
| `user-invocable`         | No       | `false` = hidden from `/` menu; Claude-only background knowledge. Default: `true`. |
| `allowed-tools`          | No       | Tools usable without approval when skill is active. E.g. `Read, Grep, Bash(gh *)`. |
| `model`                  | No       | Model to use when this skill is active. |
| `context`                | No       | Set to `fork` to run in an isolated subagent. |
| `agent`                  | No       | Subagent type when `context: fork` is set. Options: `Explore`, `Plan`, `general-purpose`, or any custom agent. |
| `hooks`                  | No       | Lifecycle hooks scoped to this skill. |

### Invocation control matrix

| Setting                          | You can invoke | Claude auto-invokes | Description in context |
|----------------------------------|----------------|---------------------|------------------------|
| (default)                        | Yes            | Yes                 | Always |
| `disable-model-invocation: true` | Yes            | No                  | Not in context |
| `user-invocable: false`          | No             | Yes                 | Always |

---

## Arguments / String Substitutions

| Placeholder            | Meaning |
|------------------------|---------|
| `$ARGUMENTS`           | All arguments passed to the skill |
| `$ARGUMENTS[N]`        | Argument at 0-based index N |
| `$N`                   | Shorthand for `$ARGUMENTS[N]` |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}`  | Directory containing the skill's `SKILL.md` |

If `$ARGUMENTS` is absent from content, Claude Code appends `ARGUMENTS: <value>` automatically.

### Example

```markdown
---
name: migrate-component
description: Migrate a component from one framework to another
---

Migrate the $0 component from $1 to $2.
Preserve all existing behavior and tests.
```

Usage: `/migrate-component SearchBar React Vue`

---

## Types of Skill Content

### Reference/Knowledge skill
Adds domain knowledge Claude applies inline. No side effects.

```markdown
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
- Include request validation
```

### Task/Action skill
Step-by-step instructions for a specific action (deploy, commit, etc.). Usually set `disable-model-invocation: true`.

```markdown
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---

Deploy $ARGUMENTS to production:
1. Run the test suite
2. Build the application
3. Push to the deployment target
4. Verify the deployment succeeded
```

---

## Advanced Patterns

### Dynamic context injection

Use `` !`command` `` to run shell commands before the skill content is sent to Claude. Output replaces the placeholder — Claude only sees the final rendered result.

```markdown
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

### Run in a subagent (`context: fork`)

The skill content becomes the subagent's prompt. It runs in isolation (no access to conversation history).

```markdown
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

Built-in agent types: `Explore` (read-only codebase exploration), `Plan`, `general-purpose`.  
Custom agents from `.claude/agents/` can also be referenced.

### Enable extended thinking

Include the word `ultrathink` anywhere in skill content.

---

## Restricting Claude's Access to Skills

Three ways to control which skills Claude can invoke:

1. **Deny the Skill tool globally** in `/permissions`:
   ```
   # Add to deny rules:
   Skill
   ```

2. **Allow or deny specific skills** via permission rules:
   ```
   # Allow only specific skills
   Skill(commit)
   Skill(review-pr *)

   # Deny specific skills
   Skill(deploy *)
   ```
   Syntax: `Skill(name)` for exact match, `Skill(name *)` for prefix match.

3. **Per-skill**: add `disable-model-invocation: true` to frontmatter.

---

## Creating a Personal (Global) Skill

Personal skills are available across **all projects**.

```bash
# 1. Create the skill directory
mkdir -p ~/.claude/skills/my-skill

# 2. Create SKILL.md
# (edit ~/.claude/skills/my-skill/SKILL.md)
```

---

## Creating a Project (Local) Skill

Project skills are available only in **this project**.

```bash
# 1. Create the skill directory
mkdir -p .claude/skills/my-skill

# 2. Create SKILL.md
# (edit .claude/skills/my-skill/SKILL.md)
```

Commit `.claude/skills/` to version control to share with the team.

---

## Sharing Skills

| Method          | How |
|-----------------|-----|
| Project-scoped  | Commit `.claude/skills/` to version control |
| Plugin          | Add a `skills/` directory inside a plugin package |
| Organization    | Deploy via managed settings (enterprise) |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Skill doesn't trigger automatically | Check description has keywords matching user's natural phrasing; invoke directly with `/skill-name` |
| Skill triggers too often | Make description more specific; add `disable-model-invocation: true` |
| Claude doesn't see all skills | Descriptions have a character budget (2% of context window, ~16k chars fallback); override with `SLASH_COMMAND_TOOL_CHAR_BUDGET` env var; check `/context` for warnings |
| Skill with `context: fork` does nothing | Ensure content has explicit task instructions, not just background guidelines |
