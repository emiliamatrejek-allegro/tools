# AI Rules — tools repo

## Czym jest to repo

Warsztat do budowania narzędzi AI dla GitHub Copilot w VS Code: agentów, promptów, skillów, trybów czatu.

## Źródło prawdy: prompty

`github-copilot-prompts/` zawiera wszystkie prompty i agentów.
Po każdej zmianie uruchom: `.\scripts\sync-prompts.ps1`
Skrypt kopiuje pliki do `~\.github\prompts\` i `AppData\Roaming\Code\User\prompts\`.

## Jak dodać nowy prompt

1. Stwórz plik w `github-copilot-prompts/` z rozszerzeniem `.prompt.md`, `.agent.md`, `.instructions.md` lub `.chatmode.md`
2. Dodaj frontmatter z `mode`, `description`, `tools`
3. Uruchom `sync-prompts.ps1`

## Stack

- GitHub Copilot w VS Code (główne narzędzie)
- Python 3.11+, BigQuery, Streamlit, pandas (kontekst projektów które obsługują prompty)
- Allegro internal: Jarvis MSC / Airflow DAGs, Allegro BigQuery (`sc-16612-jarvis-cloud-prod`)

## Czego NIE robić

- Nie edytuj plików bezpośrednio w `~\.github\prompts\` — edytuj w repo i syncuj
- Nie twórz duplikatów promptów w `.github/prompts/` tego repo (to folder dla lokalnych override'ów)
