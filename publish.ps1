# Publish this folder to GitHub Pages.
#
#   .\publish.ps1 -RepoUrl https://github.com/<user>/<repo>.git
#
# Run it after creating an empty repository on GitHub. It sets the remote, commits everything and
# pushes to main; the only step left is enabling Pages in the repository settings, which the script
# prints at the end. Re-run it after any edit to publish the change.

param(
    [Parameter(Mandatory = $true)]
    [string]$RepoUrl,
    [string]$Branch = "main",
    [string]$Message = "Project page for UniSIR"
)

$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host "  FAILED  $msg" -ForegroundColor Red
    exit 1
}

Write-Host "publishing $PSScriptRoot"
Push-Location $PSScriptRoot
try {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Fail "git is not on PATH" }

    if (-not (Test-Path ".git")) {
        git init -b $Branch 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { Fail "could not initialise the repository" }
        Write-Host "  initialised a repository on branch $Branch"
    }

    $remotes = git remote
    if ($remotes -contains "origin") {
        git remote set-url origin $RepoUrl
    } else {
        git remote add origin $RepoUrl
    }
    Write-Host "  origin -> $RepoUrl"

    # a commit identity, if the machine has none configured
    $ident = @()
    if (-not (git config user.email)) {
        $ident = @("-c", "user.name=UniSIR", "-c", "user.email=unisir@example.com")
    }

    git add -A
    if ($LASTEXITCODE -ne 0) { Fail "git add failed" }
    git @ident commit -m $Message 2>&1 | ForEach-Object { "  $_" }
    if ($LASTEXITCODE -ne 0 -and -not (git log --oneline -1 2>$null)) { Fail "nothing to commit" }

    git push -u origin $Branch
    if ($LASTEXITCODE -ne 0) {
        Fail "push failed -- is the repository empty and are you signed in? (git credential manager, or a personal access token as the password)"
    }

    # work out the Pages URL from the remote
    $url = $RepoUrl.TrimEnd(".git")
    $site = "https://<user>.github.io/<repo>/"
    if ($url -match "github\.com[:/](?<user>[^/]+)/(?<repo>[^/]+)$") {
        $site = "https://$($Matches.user).github.io/$($Matches.repo)/"
    }
    Write-Host ""
    Write-Host "  pushed to $RepoUrl ($Branch)" -ForegroundColor Green
    Write-Host ""
    Write-Host "  last step, once:"
    Write-Host "    Settings -> Pages -> Source: Deploy from a branch"
    Write-Host "    Branch: $Branch   Folder: / (root)   ->  Save"
    Write-Host ""
    Write-Host "  the page will be at $site"
}
finally {
    Pop-Location
}
