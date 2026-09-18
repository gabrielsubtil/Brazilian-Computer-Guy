<#
.SYNOPSIS
    Coleta de Diagnóstico Completo do Sistema (Somente Leitura) — Brazilian Computer Guy
.DESCRIPTION
    Este script coleta informações essenciais de hardware, sistema operacional, 
    espaço em disco, serviços em falha e eventos críticos recentes.
    NÃO MODIFICA NENHUMA CONFIGURAÇÃO OU ARQUIVO DO SISTEMA.
#>

[CmdletBinding()]
param(
    [switch]$AsJson
)

$ErrorActionPreference = "SilentlyContinue"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host " BRAZILIAN COMPUTER GUY — DIAGNÓSTICO DO SISTEMA " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Informações do Sistema Operacional
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem

$diagnostic = [ordered]@{
    DataHora = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Maquina = $env:COMPUTERNAME
    Usuario = $env:USERNAME
    SistemaOperacional = $os.Caption
    VersaoSO = $os.Version
    Build = $os.BuildNumber
    Arquitetura = $os.OSArchitecture
    Fabricante = $cs.Manufacturer
    Modelo = $cs.Model
    Processador = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
    MemoriaTotalGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    MemoriaLivreGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
}

# 2. Volumes de Disco
$volumes = Get-Volume | Where-Object DriveType -eq "Fixed" | ForEach-Object {
    [ordered]@{
        Unidade = $_.DriveLetter
        Nome = $_.FileSystemLabel
        TamanhoGB = [math]::Round($_.Size / 1GB, 2)
        LivreGB = [math]::Round($_.SizeRemaining / 1GB, 2)
        PercentualLivre = [math]::Round(($_.SizeRemaining / $_.Size) * 100, 1)
    }
}
$diagnostic["Discos"] = $volumes

# 3. Serviços com Inicialização Automática que estão Parados
$failedServices = Get-CimInstance Win32_Service | 
    Where-Object { $_.StartMode -eq "Auto" -and $_.State -ne "Running" } | 
    ForEach-Object {
        [ordered]@{
            Nome = $_.Name
            NomeExibicao = $_.DisplayName
            Estado = $_.State
            ExitCode = $_.ExitCode
        }
    }
$diagnostic["ServicosAutoParados"] = $failedServices

# 4. Erros Críticos Recentes no Event Log (Últimas 24h)
$recentErrors = Get-WinEvent -FilterHashtable @{
    LogName = 'System', 'Application'
    Level = 1, 2
    StartTime = (Get-Date).AddHours(-24)
} -MaxEvents 10 | ForEach-Object {
    [ordered]@{
        DataHora = $_.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
        Log = $_.LogName
        Fonte = $_.ProviderName
        Id = $_.Id
        Mensagem = ($_.Message -split "`n")[0]
    }
}
$diagnostic["ErrosRecentes"] = $recentErrors

if ($AsJson) {
    $diagnostic | ConvertTo-Json -Depth 4
} else {
    Write-Host "`n[+] Informações Gerais:" -ForegroundColor Green
    Write-Host "  Máquina: $($diagnostic.Maquina) ($($diagnostic.Fabricante) $($diagnostic.Modelo))"
    Write-Host "  SO: $($diagnostic.SistemaOperacional) (Build $($diagnostic.Build))"
    Write-Host "  CPU: $($diagnostic.Processador)"
    Write-Host "  RAM: $($diagnostic.MemoriaLivreGB) GB livres de $($diagnostic.MemoriaTotalGB) GB"

    Write-Host "`n[+] Armazenamento:" -ForegroundColor Green
    foreach ($v in $diagnostic.Discos) {
        Write-Host "  Drive $($v.Unidade): $($v.LivreGB) GB livres de $($v.TamanhoGB) GB ($($v.PercentualLivre)% livre)"
    }

    Write-Host "`n[+] Serviços Automáticos com Falha/Parados ($($diagnostic.ServicosAutoParados.Count)):" -ForegroundColor Yellow
    foreach ($s in $diagnostic.ServicosAutoParados) {
        Write-Host "  - $($s.Nome) ($($s.NomeExibicao)): Estado = $($s.Estado)"
    }

    Write-Host "`n[+] Erros Críticos Recentes no Event Viewer ($($diagnostic.ErrosRecentes.Count)):" -ForegroundColor Red
    foreach ($e in $diagnostic.ErrosRecentes) {
        Write-Host "  - [$($e.DataHora)] [$($e.Log)] ID $($e.Id) ($($e.Fonte)): $($e.Mensagem)"
    }
    Write-Host "`nDiagnóstico concluído em modo SOMENTE LEITURA." -ForegroundColor Cyan
}
