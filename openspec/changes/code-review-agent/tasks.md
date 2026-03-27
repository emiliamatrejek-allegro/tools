# Tasks: Code Review Agent

## Implementation

- [x] Utwórz plik `github-copilot-prompts/docs/code-review/code-review-universal.agent.md`
  - Dodaj YAML frontmatter z listą narzędzi
  - Napisz sekcję `<role>` — senior reviewer, language-agnostic
  - Napisz sekcję `<self_reflection>` — budowanie wewnętrznego rubric
  - Napisz sekcję analizy z 4 fazami (quick scan, deep, security, tests)
  - Napisz sekcję `<output_format>` z ustandaryzowaną strukturą (Executive Summary, Critical Issues, Improvements, Suggestions, Security Notes, Score)
  - Dodaj sekcję `<persistence>` — nie przerywać, nie pytać o kontekst

- [x] Sprawdź `build-gallery.js` czy wymaga rejestracji nowego pliku
  - Jeśli tak: zaktualizuj gallery config lub mapę plików

- [x] Zweryfikuj: otwórz agent w VS Code i potwierdź, że frontmatter jest poprawny
