# Proposal: Code Review Agent

## What

Agent do review kodu jako plik `.agent.md` lub `.chatmode.md` — konfiguracja GitHub Copilot w trybie agentowym, gotowa do użycia w VS Code.

Agent ma być **ogólny (language-agnostic)**, działający z dowolnym językiem i stackiem, skupiony na jakości kodu, bezpieczeństwie i dobrych praktykach.

## Why

Istniejący plik `pr-review-kotlin-groovy-gpt-5.chatmode.md` obsługuje tylko Kotlin/Groovy/Spring Boot. Brakuje:
- agenta uniwersalnego do reviewu kodu w dowolnym języku
- agenta w nowym formacie `.agent.md` (tryb agentowy zamiast chat mode)
- ustandaryzowanego procesu reviewu z jasną strukturą outputu

## Non-goals

- Nie zastępuje istniejącego agenta Kotlin/Groovy
- Nie integruje się z zewnętrznymi narzędziami CI/CD
- Nie generuje automatycznych PR comments (tylko output do rozmowy)

## Success criteria

- Agent poprawnie identyfikuje: błędy krytyczne, zapachy kodu, problemy bezpieczeństwa
- Output jest czytelny i zawiera konkretne, actionable sugestie
- Działa z JS/TS, Python, Java, Kotlin, Go i innymi językami
