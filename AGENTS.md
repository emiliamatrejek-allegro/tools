# AI Rules — tools repo

> Źródło prawdy dla instrukcji AI w tym repo.
> Po zmianach uruchom `scripts/sync-ai-rules.sh`, żeby zaktualizować `.github/copilot-instructions.md` i `.windsurfrules`.

---

## Czym jest to repo

Warsztat do budowania narzędzi AI dla GitHub Copilot w VS Code: agentów, promptów, skillów i trybów czatu.  
Użytkownikiem końcowym są analitycy danych (Data Science @ Allegro). Narzędzia wspierają BigQuery, Streamlit, DAG-i Airflow.

## Źródło prawdy: `github-copilot-prompts/`

**Zawsze edytuj pliki w `github-copilot-prompts/`**, nigdy bezpośrednio w `~\.github\prompts\`.  
Po każdej zmianie uruchom: `.\scripts\sync-prompts.ps1`  
Skrypt kopiuje do `~\.github\prompts\` i `AppData\Roaming\Code\User\prompts\`.

## Typy plików i rozszerzenia

| Rozszerzenie | Typ | Narzędzie |
|---|---|---|
| `.prompt.md` | Prompt (komenda `/`) | `mode: agent` lub `mode: ask` |
| `.agent.md` | Custom agent (subagent) | `mode: agent` |
| `.instructions.md` | Instrukcje (stałe, `applyTo`) | brak frontmatter `mode` |
| `.chatmode.md` | Tryb czatu | `mode: agent` |
| `SKILL.md` | Skill (workflow) | w folderze `.github/skills/<name>/` |

**Wymagany frontmatter** dla prompt/agent/chatmode:
```yaml
---
mode: agent          # agent | ask | edit
description: "..."   # KLUCZOWE: to decyduje czy agent go załaduje
tools:
  - codebase
  - mcp_omnidoc_omnidoc
---
```

## Struktura repo

```
github-copilot-prompts/   ← EDYTUJ TUTAJ (źródło prawdy)
  *.prompt.md / *.agent.md / *.instructions.md / *.chatmode.md
  docs/                   ← prompty z galerii (nie zmieniaj)
  git-flow/               ← komendy git

.github/
  copilot-instructions.md ← generowany przez sync-ai-rules (nie edytuj ręcznie)
  prompts/                ← lokalne override'y (nie duplikuj github-copilot-prompts/)
  skills/                 ← skills OpenSpec (apply/archive/explore/propose)

openspec/
  config.yaml             ← kontekst projektu dla OpenSpec
  changes/                ← aktywne zmiany: proposal.md + design.md + tasks.md
  changes/archive/        ← ukończone zmiany

scripts/
  sync-prompts.ps1        ← kopiuje github-copilot-prompts/ → globalne lokalizacje
  sync-ai-rules.sh        ← kopiuje AGENTS.md → copilot-instructions.md + .windsurfrules
```

## Dodawanie nowego promptu / agenta

1. Stwórz plik w `github-copilot-prompts/` z właściwym rozszerzeniem
2. Dodaj frontmatter (`mode`, `description`, `tools`)
3. Uruchom `.\scripts\sync-prompts.ps1`
4. Sprawdź czy pojawia się w VS Code jako `/nazwa-komendy`

Dla większych zmian: użyj workflow OpenSpec (`/opsx-propose`).

## OpenSpec workflow

Komenda: `/opsx-propose` → `/opsx-apply` → `/opsx-archive`  
Skills w `.github/skills/`: `openspec-propose`, `openspec-apply-change`, `openspec-archive-change`, `openspec-explore`

## Czego NIE robić

- Nie edytuj plików bezpośrednio w `~\.github\prompts\` — edytuj w repo i syncuj
- Nie twórz duplikatów promptów w `.github/prompts/` tego repo
- Nie dodawaj `applyTo: "**"` do instrukcji bez potrzeby — spala niepotrzebnie kontekst
- Nie pisz `description` po polsku z dwukropkiem bez cudzysłowów (błąd YAML)
