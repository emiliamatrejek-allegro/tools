# sync-prompts.ps1
# Kopiuje wszystkie pliki z github-copilot-prompts/ do globalnych lokalizacji VS Code.
# Uruchom po każdej zmianie w github-copilot-prompts/.
#
# Użycie:
#   .\scripts\sync-prompts.ps1

$source = Join-Path $PSScriptRoot "..\github-copilot-prompts"
$targets = @(
    "$env:USERPROFILE\.github\prompts",
    "$env:APPDATA\Code\User\prompts"
)

$files = Get-ChildItem $source -File | Where-Object {
    # Pomijamy pliki techniczne repo, nie będące promptami
    $_.Name -notin @('.gitignore', 'package.json', 'build-gallery.js', 'README.md')
}

foreach ($target in $targets) {
    if (!(Test-Path $target)) {
        New-Item -ItemType Directory -Path $target -Force | Out-Null
    Write-Host "Stworzono folder: $target"
    }

    foreach ($file in $files) {
        $dest = Join-Path $target $file.Name
        Copy-Item $file.FullName $dest -Force
    }

    Write-Host "OK [$($files.Count) pliki] -> $target"
}

Write-Host ""
Write-Host "Sync zakonczony. Skopiowane pliki:"
$files | ForEach-Object { Write-Host "  - $($_.Name)" }
