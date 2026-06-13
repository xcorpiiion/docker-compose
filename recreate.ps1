# recreate.ps1 - Recria um ou mais containers do Docker Compose
# Uso: .\recreate.ps1
# Ou direto: .\recreate.ps1 -Services authorization-api

param(
    [string[]]$Services = @()
)

$AllServices = @(
    "authorization-api",
    "registry-api",
    "user-api",
    "gateway-api",
    "souls-guide-api",
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

if ($Services.Count -eq 0)
{
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "          RECRIAR CONTAINER             " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    $num = 1
    foreach ($s in $AllServices)
    {
        Write-Host "  [$num] $s" -ForegroundColor Yellow
        $num++
    }
    Write-Host "  [0] TODOS" -ForegroundColor Red
    Write-Host ""

    $escolha = Read-Host "Escolha (ex: 1 ou 1,3,5)"

    if ($escolha -eq "0")
    {
        $Services = $AllServices
    }
    else
    {
        $indices = $escolha -split "," | ForEach-Object { $_.Trim() }
        $Services = $indices | ForEach-Object {
            $idx = [int]$_ - 1
            if ($idx -ge 0 -and $idx -lt $AllServices.Count)
            {
                $AllServices[$idx]
            }
        }
    }
}

if ($Services.Count -eq 0)
{
    Write-Host "Nenhum servico selecionado." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Recriando: $( $Services -join ', ' )" -ForegroundColor Green
Write-Host ""

docker-compose up -d --force-recreate $Services

Write-Host ""
Write-Host "Pronto!" -ForegroundColor Green