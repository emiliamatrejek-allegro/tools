# AI Rules — tools repo

> Generowany z `AGENTS.md` przez `scripts/sync-ai-rules.sh`. Edytuj tam, nie tutaj.

---

## Czym jest to repo

Warsztat do budowania narzędzi AI dla GitHub Copilot w VS Code: agentów, promptów, skillów i trybów czatu.  
Użytkownikiem końcowym są analitycy danych (Data Science @ Allegro). Narzędzia wspierają BigQuery, Streamlit, DAG-i Airflow.

## Źródło prawdy: `github-copilot-prompts/`

**Zawsze edytuj pliki w `github-copilot-prompts/`**, nigdy bezpośrednio w `~\.github\prompts\`.  
Po każdej zmianie uruchom: `.\scripts\sync-prompts.ps1`

## Typy plików i rozszerzenia

| Rozszerzenie | Typ | Frontmatter |
|---|---|---|
| `.prompt.md` | Prompt (`/komenda`) | `mode: agent\|ask\|edit` |
| `.agent.md` | Custom agent | `mode: agent` |
| `.instructions.md` | Stałe instrukcje (`applyTo`) | brak `mode` |
| `.chatmode.md` | Tryb czatu | `mode: agent` |
| `SKILL.md` | Skill (workflow) | w folderze `.github/skills/<name>/` |

**`description` jest kluczowy** — decyduje czy agent załaduje plik. Zawsze wypełniaj.

## Struktura repo

```
github-copilot-prompts/   ← EDYTUJ TUTAJ (źródło prawdy)
.github/
  prompts/                ← lokalne override'y (nie duplikuj github-copilot-prompts/)
  skills/                 ← OpenSpec skills
openspec/
  changes/                ← aktywne zmiany (proposal + design + tasks)
  changes/archive/        ← ukończone
scripts/
  sync-prompts.ps1        ← kopiuje do globalnych lokalizacji VS Code
```

## Czego NIE robić

- Nie edytuj plików w `~\.github\prompts\` — edytuj w repo i syncuj
- Nie twórz duplikatów w `.github/prompts/` tego repo
- Nie używaj `applyTo: "**"` bez potrzeby
- `description` z dwukropkiem bez cudzysłowów → błąd YAML
