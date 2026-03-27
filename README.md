# tools — AI Copilot Workshop

Osobisty warsztat do budowania narzędzi AI: agentów, promptów, skillów i trybów czatu dla GitHub Copilot w VS Code.

`github-copilot-prompts/` to **źródło prawdy** dla wszystkich narzędzi. Po każdej zmianie uruchom skrypt sync, który kopiuje pliki do globalnych lokalizacji VS Code.

---

## Struktura repo

```
tools/
├── .github/                         <- konfiguracja Copilota (ładowana automatycznie)
│   ├── copilot-instructions.md      <- globalne instrukcje dla Copilota w tym repo
│   ├── prompts/                     <- prompts dostępne lokalnie (.github/prompts)
│   │   ├── code-review-universal.agent.md
│   │   ├── opsx-*.prompt.md         <- komendy OpenSpec workflow
│   │   └── ...
│   └── skills/                      <- skille OpenSpec (apply, archive, explore, propose)
│
├── github-copilot-prompts/          <- ŹRÓDŁO PRAWDY: wszystkie prompty, agenci, skille
│   ├── create-dag.prompt.md         <- tworzenie DAG-ów Airflow (Jarvis MSC)
│   ├── sql-catalog.instructions.md  <- katalog tabel BQ (stała instrukcja, applyTo: **)
│   ├── sql-query-builder.prompt.md  <- budowanie zapytań SQL
│   ├── new-project.agent.md         <- scaffold nowego projektu data science
│   ├── data-discovery.agent.md      <- znajdowanie danych w BigQuery
│   ├── data-health-check.agent.md   <- sprawdzanie jakości danych
│   ├── ab-test-report.agent.md      <- raportowanie wyników A/B
│   ├── write-eda.prompt.md          <- exploratory data analysis
│   ├── write-business-summary.prompt.md <- komunikacja biznesowa wyników
│   ├── sanity-check.prompt.md       <- weryfikacja analizy przed publishem
│   ├── build-my-agent.prompt.md     <- scaffold nowego agenta/prompta
│   ├── continue.prompt.md           <- sprawdzenie stanu projektu
│   ├── lineage-trace.skills.md      <- śledzenie lineage danych
│   ├── weekly-status.prompt.md      <- tygodniowy status projektu
│   ├── ds-core.instructions.md      <- stałe instrukcje dla analityka DS
│   ├── ds-analyst.chatmode.md       <- tryb czatu: analityk danych
│   ├── code-reviewer.chatmode.md    <- tryb czatu: code review
│   ├── docs/                        <- prompty z galerii Allegro (chat modes, skills)
│   └── git-flow/                    <- prompty do pracy z gitem
│
├── openspec/                        <- spec-driven workflow dla nowych funkcjonalności
│   ├── config.yaml                  <- konfiguracja projektu (kontekst, reguły)
│   ├── changes/                     <- aktywne i zarchiwizowane zmiany
│   │   ├── archive/                 <- ukończone zmiany
│   │   └── <TICKET>_<nazwa>/        <- aktywna zmiana: proposal.md, design.md, tasks.md
│   └── specs/                       <- specyfikacje projektowe
│
├── scripts/
│   ├── sync-prompts.ps1             <- SYNC: kopiuje github-copilot-prompts/ -> globalne lokalizacje
│   ├── sync-ai-rules.sh             <- sync AGENTS.md -> .windsurfrules -> copilot-instructions
│   └── init-openspec.sh             <- inicjalizacja nowej zmiany w OpenSpec
│
├── AGENTS.md                        <- instrukcje AI (źródło dla sync-ai-rules)
├── CLAUDE.md                        <- instrukcje dla Claude
└── .windsurfrules                   <- instrukcje dla Windsurf
```

---

## Workflow: edycja promptów

```
1. Edytuj plik w  github-copilot-prompts/
2. Uruchom sync:  .\scripts\sync-prompts.ps1
3. Commituj zmiany do repo
```

Skrypt kopiuje wszystkie prompty do:
- `~\.github\prompts\` — główna lokalizacja globalna
- `~\AppData\Roaming\Code\User\prompts\` — kopia dla VS Code (Windows)

---

## OpenSpec workflow

OpenSpec to spec-driven workflow do budowania nowych narzędzi krok po kroku.

```
/opsx-propose  → opisz pomysł → AI generuje proposal + design + tasks
/opsx-explore  → think-through mode, eksploracja przed decyzją
/opsx-apply    → implementuj kolejny task z listy
/opsx-archive  → zamknij finished change
```

Komendy dostępne jako prompty w `.github/prompts/opsx-*.prompt.md`.

---

## Jak dodać nowy prompt

1. Stwórz plik w `github-copilot-prompts/` z odpowiednim rozszerzeniem:
   - `.prompt.md` — ogólny prompt / agent mode
   - `.agent.md` — tryb agentowy (pełen dostęp do narzędzi)
   - `.instructions.md` — stała instrukcja (`applyTo` w frontmatter)
   - `.chatmode.md` — tryb czatu

2. Dodaj frontmatter:
```yaml
---
mode: agent          # agent | chat | edit
description: "Opis widoczny w palecie komend"
tools:
  - codebase
  - search
---
```

3. Uruchom `.\scripts\sync-prompts.ps1`

---

## Jak uruchomić prompt w VS Code

`Ctrl+Shift+P` → `Run Prompt` → wybierz z listy
