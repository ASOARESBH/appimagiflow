[CmdletBinding()]
param(
    [switch]$RefreshProject
)

$ErrorActionPreference = 'Stop'

$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if ($null -eq $flutterCommand) {
    throw "Flutter não foi encontrado no PATH. Configure o SDK Flutter no PATH ou execute este script pelo terminal do Android Studio após configurar o plugin Flutter."
}

Write-Host "`n== ImagiFlow: atualização do Flutter ==" -ForegroundColor Cyan
Write-Host "SDK atual:" -ForegroundColor Yellow
& flutter --version

Write-Host "`nSelecionando o canal estável..." -ForegroundColor Yellow
& flutter channel stable

Write-Host "`nAtualizando o SDK Flutter..." -ForegroundColor Yellow
& flutter upgrade

Write-Host "`nDiagnóstico do ambiente:" -ForegroundColor Yellow
& flutter doctor -v

if ($RefreshProject) {
    $projectRoot = Split-Path -Parent $PSScriptRoot
    Push-Location $projectRoot
    try {
        Write-Host "`nAtualizando dependências e verificando o projeto..." -ForegroundColor Yellow
        & flutter clean
        & flutter pub get
        & flutter analyze
    }
    finally {
        Pop-Location
    }
}

Write-Host "`nAtualização concluída." -ForegroundColor Green
