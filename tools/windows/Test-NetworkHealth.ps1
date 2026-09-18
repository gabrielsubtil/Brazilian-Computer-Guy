<#
.SYNOPSIS
    Diagnóstico Rápido de Saúde de Rede (Somente Leitura) — Brazilian Computer Guy
#>

[CmdletBinding()]
param(
    [string]$TargetHost = "1.1.1.1",
    [string]$TestDomain = "microsoft.com"
)

Write-Host "--- Testando Conectividade de Rede ---" -ForegroundColor Cyan

# 1. Loopback
$loop = Test-Connection -ComputerName 127.0.0.1 -Count 2 -Quiet
Write-Host "1. Pilha TCP/IP Local (127.0.0.1): $(if($loop){'OK'}else{'FALHA'})" -ForegroundColor $(if($loop){'Green'}else{'Red'})

# 2. Gateway
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue).NextHop | Select-Object -First 1
if ($gateway) {
    $gwPing = Test-Connection -ComputerName $gateway -Count 2 -Quiet
    Write-Host "2. Gateway Padrão ($gateway): $(if($gwPing){'OK'}else{'FALHA/SEM RESPOSTA'})" -ForegroundColor $(if($gwPing){'Green'}else{'Yellow'})
} else {
    Write-Host "2. Gateway Padrão: Não detectado" -ForegroundColor Red
}

# 3. Internet IP
$extPing = Test-Connection -ComputerName $TargetHost -Count 2 -Quiet
Write-Host "3. Conectividade Internet IP ($TargetHost): $(if($extPing){'OK'}else{'FALHA'})" -ForegroundColor $(if($extPing){'Green'}else{'Red'})

# 4. Resolução DNS
try {
    $dns = Resolve-DnsName -Name $TestDomain -ErrorAction Stop | Select-Object -First 1
    Write-Host "4. Resolução de Nomes DNS ($TestDomain): OK (IP: $($dns.IPAddress))" -ForegroundColor Green
} catch {
    Write-Host "4. Resolução de Nomes DNS ($TestDomain): FALHA" -ForegroundColor Red
}
