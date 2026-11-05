#Requires -Version 5.1
<#
.SYNOPSIS
    Brazilian Computer Guy (BCG) — Verificação da camada Computer Use.
.DESCRIPTION
    SOMENTE LEITURA: não instala, não configura e não dirige a interface.
    Referência: ../../docs/computer-use.md
    agent-desktop: Vercel Labs, Apache-2.0.
    https://github.com/vercel-labs/agent-desktop
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'SilentlyContinue'
$script:Checks = New-Object System.Collections.ArrayList
function Write-Result {
    param([string]$Level, [string]$Name, [string]$Detail)
    [void]$script:Checks.Add([pscustomobject]@{ Nivel = $Level; Verificacao = $Name; Detalhe = $Detail })
    Write-Output "[$Level] ${Name}: $Detail"
}
function Write-Ok { param([string]$Name, [string]$Detail) Write-Result 'OK' $Name $Detail }
function Write-Warn { param([string]$Name, [string]$Detail) Write-Result 'AVISO' $Name $Detail }
function Write-Fail { param([string]$Name, [string]$Detail) Write-Result 'FALHA' $Name $Detail }
function Write-Summary {
    Write-Output "`n[+] Matriz de verificações:"
    foreach ($row in $script:Checks) { Write-Output ('{0,-6} | {1}: {2}' -f $row.Nivel, $row.Verificacao, $row.Detalhe) }
    $ok = @($script:Checks | Where-Object Nivel -eq 'OK').Count
    $warn = @($script:Checks | Where-Object Nivel -eq 'AVISO').Count
    $fail = @($script:Checks | Where-Object Nivel -eq 'FALHA').Count
    Write-Output "Resumo: OK=$ok | AVISO=$warn | FALHA=$fail"
    Write-Output 'Diagnóstico concluído em modo SOMENTE LEITURA.'
}
# Job isolado permite limitar também launchers npm .cmd/.ps1 sem arquivos temporários.
# Stop-Job termina somente o processo de diagnóstico criado por este script.
function Invoke-ReadOnly {
    param([string]$Path, [string[]]$Arguments)
    $job = $null
    try {
        $job = Start-Job -ErrorAction Stop -ScriptBlock {
            param($Executable, $CommandArguments)
            $ErrorActionPreference = 'SilentlyContinue'
            try {
                $global:LASTEXITCODE = 0
                $text = (& $Executable @CommandArguments 2>&1 | Out-String)
                $succeeded = $?
                $code = $LASTEXITCODE
                if (-not $succeeded -and $code -eq 0) { $code = 1 }
                [pscustomobject]@{ Code = $code; Text = $text.Trim() }
            } catch { [pscustomobject]@{ Code = 1; Text = '' } }
        } -ArgumentList $Path, $Arguments
        $finished = Wait-Job -Job $job -Timeout 20 -ErrorAction SilentlyContinue
        if ($null -eq $finished) { return [pscustomobject]@{ Code = 124; Text = '' } }
        $result = Receive-Job -Job $job -ErrorAction SilentlyContinue
        if ($null -eq $result -or $null -eq $result.Code) { return [pscustomobject]@{ Code = 1; Text = '' } }
        return $result
    } catch { return [pscustomobject]@{ Code = 1; Text = '' } }
    finally {
        if ($null -ne $job) {
            Stop-Job -Job $job -ErrorAction SilentlyContinue
            Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
        }
    }
}
function Get-EnvelopeText {
    # O launcher npm pode imprimir um aviso antes do envelope JSON de uma linha.
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return $Text }
    $t = $Text.Trim()
    if ($t.StartsWith('{')) { return $t }
    $i = $t.IndexOf('{')
    if ($i -ge 0) { return $t.Substring($i) }
    return $t
}
function Convert-Envelope {
    param([string]$Text)
    $obj = ConvertFrom-Json -InputObject (Get-EnvelopeText $Text) -ErrorAction Stop
    if ($null -eq $obj) { throw 'JSON vazio' }
    if ($obj.PSObject.Properties['ok'] -and $obj.ok -eq $false) { throw 'Comando recusado' }
    if ($obj.PSObject.Properties['data']) { return ,$obj.data }
    return ,$obj
}
function Get-PermissionIssueCount {
    param($Value)
    if ($null -eq $Value) { return 1 }
    if ($Value -is [bool]) { if (-not $Value) { return 1 }; return 0 }
    if ($Value -is [string]) {
        if ($Value -in @('denied', 'not_granted', 'unknown', 'not_determined', 'restricted')) { return 1 }
        return 0
    }
    $count = 0
    if ($Value -is [array]) {
        foreach ($item in $Value) { $count += Get-PermissionIssueCount $item }
    } elseif ($Value -is [pscustomobject]) {
        foreach ($property in $Value.PSObject.Properties) { $count += Get-PermissionIssueCount $property.Value }
    }
    return $count
}
Write-Output '===================================================='
Write-Output ' BRAZILIAN COMPUTER GUY — COMPUTER USE'
Write-Output ' SOMENTE LEITURA'
Write-Output '===================================================='
$desktop = Get-Command agent-desktop -CommandType Application,ExternalScript -ErrorAction SilentlyContinue | Select-Object -First 1
if ($null -eq $desktop) {
    Write-Fail 'Binário' 'agent-desktop não encontrado no PATH. Instalação manual: npm install -g agent-desktop'
    Write-Summary
    exit 2
}
Write-Ok 'Binário' 'agent-desktop encontrado no PATH'
foreach ($tool in @('node', 'npm')) {
    $command = Get-Command $tool -CommandType Application,ExternalScript -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $command) { Write-Warn $tool 'Não encontrado no PATH (informativo)'; continue }
    $result = Invoke-ReadOnly $command.Source @('--version')
    if ($result.Code -ne 0) { Write-Warn $tool "Não foi possível consultar a versão (código $($result.Code))"; continue }
    if ($tool -eq 'node') {
        if ($result.Text -match '^v?(\d+)\.' -and [int]$Matches[1] -ge 18) { Write-Ok 'Node.js' "$($result.Text) (>= 18)" }
        else { Write-Warn 'Node.js' "$($result.Text); esperado >= 18 (informativo)" }
    } else { Write-Ok 'npm' "$($result.Text) (informativo)" }
}
$result = Invoke-ReadOnly $desktop.Source @('version')
if ($result.Code -eq 0) {
    $ver = $null
    try { $ver = (Convert-Envelope $result.Text).version } catch { $ver = $null }
    if ($ver) { Write-Ok 'Versão' "$ver" } else { Write-Ok 'Versão' (Get-EnvelopeText $result.Text) }
}
else { Write-Fail 'Versão' "Consulta falhou (código $($result.Code); 124=timeout)" }
$sessionIssue = $false
foreach ($cmd in @('status', 'permissions', 'list-apps')) {
    $result = Invoke-ReadOnly $desktop.Source @($cmd)
    # Só inspeciona o erro em memória: títulos e nomes de apps não vão para a saída.
    if ($cmd -eq 'status' -and $result.Text -match '(?i)session.?0|non.interactive|interactive session|desktop session|no desktop') { $sessionIssue = $true }
    if ($result.Code -ne 0) {
        Write-Fail $cmd "Consulta falhou (código $($result.Code); detalhes omitidos por privacidade)"
        continue
    }
    try {
        $data = Convert-Envelope $result.Text
        switch ($cmd) {
            'status' {
                if ($data.platform -isnot [string] -or $data.supported_surfaces -isnot [array]) { throw 'Formato inesperado' }
                Write-Ok 'Plataforma' $data.platform
                $count = @($data.supported_surfaces).Count
                if ($count -gt 0) { Write-Ok 'Acessibilidade' "supported_surfaces=$count (disponível; não prova acesso a todo app)" }
                else { Write-Warn 'Acessibilidade' 'supported_surfaces vazio' }
                $perms = if ($null -ne $data.permissions) { $data.permissions } else { [pscustomobject]@{} }
                Write-Output ('[+] Permissões do status: ' + (ConvertTo-Json -InputObject $perms -Depth 20 -Compress))
            }
            'permissions' {
                $perms = if ($data.PSObject.Properties['permissions']) { $data.permissions } else { $data }
                if ($perms -isnot [pscustomobject] -and $perms -isnot [array]) { throw 'Formato inesperado' }
                $json = ConvertTo-Json -InputObject $perms -Depth 20 -Compress
                Write-Output "[+] Permissões: $json"
                if ((Get-PermissionIssueCount $perms) -gt 0 -or $json -in @('{}', '[]')) {
                    Write-Warn 'Permissões' 'Pendentes, negadas, desconhecidas ou não informadas; revisar os valores acima'
                } else { Write-Ok 'Permissões' 'Consulta válida; revisar requisitos específicos da plataforma' }
            }
            'list-apps' {
                $apps = if ($data -is [array]) { @($data) } else { @($data.apps) }
                if ($null -eq $apps) { throw 'Formato inesperado' }
                Write-Ok 'list-apps' "Aplicativos listados: $($apps.Count) (nomes omitidos)"
            }
        }
    } catch { Write-Fail $cmd 'Erro no envelope JSON ou formato não reconhecido' }
}
$process = Get-Process -Id $PID -ErrorAction SilentlyContinue
if ($sessionIssue -or $env:SESSIONNAME -match '^(Services|Service|Session 0)$' -or
    $env:SSH_CONNECTION -or $env:SSH_CLIENT -or ($null -ne $process -and $process.SessionId -eq 0) -or
    -not [Environment]::UserInteractive) {
    Write-Warn 'Sessão' 'Possível sessão não interativa (Session 0/serviço/SSH). Execute no desktop do usuário; heurística, não comprovação.'
} else { Write-Ok 'Sessão' 'Nenhum indício de sessão não interativa (heurística)' }
# NTFS usa ACLs, não o modo POSIX 700. Não inferir segurança com base apenas na existência.
$state = Join-Path $HOME '.agent-desktop'
if (Test-Path -LiteralPath $state -ErrorAction SilentlyContinue) {
    Write-Warn 'Estado' '~/.agent-desktop existe; Windows usa ACLs, sem equivalência direta ao modo 700. Revisar acesso manualmente; nada alterado.'
} else { Write-Ok 'Estado' '~/.agent-desktop ausente; nada criado' }
Write-Summary
if (@($script:Checks | Where-Object Nivel -ne 'OK').Count -gt 0) { exit 1 }
exit 0
