# logs.ps1 — Visualiza logs de um container do Docker Compose
# Uso: .\logs.ps1
# Ou direto: .\logs.ps1 -Service authorization-api

param(
    [string]$Service = "",
    [int]$Tail = 50,
    [switch]$Follow
)

$AllServices = @(
    "authorization-api",
    "registry-api",
    "user-api",
    "gateway-api",
    "game-api",
    "combat-api",
    "narrative-api",
    "config-server",
    "eureka-server",
    "db-postgre",
    "mongodb",
    "redis",
    "zipkin"
)

if ($Service -eq "")
{
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "             VER LOGS                   " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    $num = 1
    foreach ($s in $AllServices)
    {
        Write-Host "  [$num] $s" -ForegroundColor Yellow
        $num++
    }
    Write-Host ""

    $escolha = Read-Host "Numero do servico"
    $idx = [int]$escolha - 1

    if ($idx -lt 0 -or $idx -ge $AllServices.Count)
    {
        Write-Host "Opcao invalida." -ForegroundColor Red
        exit 1
    }

    $Service = $AllServices[$idx]

    Write-Host ""
    $tailInput = Read-Host "Quantas linhas (Enter = 50)"
    if ($tailInput -match '^\d+$')
    {
        $Tail = [int]$tailInput
    }

    $followInput = Read-Host "Follow mode s/N"
    if ($followInput -eq "s" -or $followInput -eq "S")
    {
        $Follow = $true
    }
}

Write-Host ""
Write-Host "Logs de: $Service (ultimas $Tail linhas)" -ForegroundColor Green
if ($Follow)
{
    Write-Host "Follow mode ativado - Ctrl+C para sair" -ForegroundColor DarkYellow
}
Write-Host ""

if ($Follow)
{
    docker logs --tail $Tail -f $Service
}
else
{
    docker logs --tail $Tail $Service
}