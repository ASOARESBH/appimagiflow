[CmdletBinding()]
param(
    [switch]$RefreshProject,
    [switch]$StopFlutterProcesses,
    [switch]$StopBuildProcesses
)

$ErrorActionPreference = 'Stop'

$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if ($null -eq $flutterCommand) {
    throw "Flutter não foi encontrado no PATH. Configure o SDK Flutter no PATH e execute novamente."
}

function Get-RunningProcesses([string[]]$Names) {
    return @(Get-Process -Name $Names -ErrorAction SilentlyContinue)
}

function Stop-Processes([object[]]$Processes, [string]$Description) {
    if ($Processes.Count -eq 0) {
        return
    }

    Write-Host "Encerrando $Description..." -ForegroundColor Yellow
    $Processes | Stop-Process -Force -ErrorAction Stop
    Start-Sleep -Seconds 2
}

$dartProcesses = Get-RunningProcesses @('dart', 'dartvm', 'flutter')
$gradleProcesses = @(
    Get-CimInstance Win32_Process -Filter "Name = 'java.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -match '(?i)gradle|flutter' }
)

if ($dartProcesses.Count -gt 0 -or $gradleProcesses.Count -gt 0) {
    Write-Host "`nForam encontrados processos que podem bloquear C:\flutter\bin\cache\dart-sdk:" -ForegroundColor Yellow
    $dartProcesses | ForEach-Object { Write-Host " - $($_.ProcessName) (PID $($_.Id))" }
    $gradleProcesses | ForEach-Object { Write-Host " - java/Gradle (PID $($_.ProcessId))" }

    if ($dartProcesses.Count -gt 0 -and -not $StopFlutterProcesses) {
        throw "Feche execuções flutter/dart ou execute novamente com -StopFlutterProcesses."
    }
    if ($gradleProcesses.Count -gt 0 -and -not $StopBuildProcesses) {
        throw "Feche o Android Studio e terminais Gradle, ou execute novamente com -StopBuildProcesses."
    }

    if ($StopFlutterProcesses) {
        Stop-Processes $dartProcesses 'processos Flutter e Dart'
    }
    if ($StopBuildProcesses) {
        $gradleProcesses | ForEach-Object {
            Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop
        }
        Start-Sleep -Seconds 2
    }
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
