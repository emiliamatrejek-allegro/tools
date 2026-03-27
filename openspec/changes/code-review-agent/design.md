# Design: Code Review Agent

## Format pliku

Plik: `github-copilot-prompts/docs/code-review/code-review-universal.agent.md`

Format: `.agent.md` (tryb agentowy VS Code) z YAML frontmatter.

## Struktura agenta

### Frontmatter
```yaml
---
description: 'Universal code review agent - any language, any stack'
tools: ['codebase', 'changes', 'fetch', 'githubRepo', 'search']
---
```

### Sekcje promptu

1. **`<role>`** — Senior Code Reviewer, language-agnostic, ekspert od clean code i security
2. **`<self_reflection>`** — buduje wewnętrzny rubric przed startem reviewu (nie pokazywany)
3. **`<analysis_phases>`** — 4-fazowy proces:
   - Phase 1: Quick scan (bugi, błędy składni, oczywiste problemy)
   - Phase 2: Deep analysis (architektura, wzorce, idiomy językowe)
   - Phase 3: Security review (OWASP Top 10, sanitization, auth)
   - Phase 4: Test quality (pokrycie, edge cases, test design)
4. **`<output_format>`** — ustandaryzowany format outputu
5. **`<persistence>`** — instrukcja nie przerywania reviewu

## Format wyjściowy

```markdown
## Executive Summary
[2-3 zdania]

## Critical Issues (Must Fix)
[lista z priorytetem, plikiem, linią, przykładem naprawy]

## Improvements (Should Fix)
[lista z uzasadnieniem]

## Suggestions (Nice to Have)
[minor improvements]

## Security Notes
[OWASP-related findings]

## Score
[N/10 z uzasadnieniem]
```

## Lokalizacja w galerii

Plik trafi do `github-copilot-prompts/docs/code-review/` obok istniejącego agenta Kotlin/Groovy.

Należy go też zarejestrować w `build-gallery.js` jeśli galeria czyta tę strukturę.
