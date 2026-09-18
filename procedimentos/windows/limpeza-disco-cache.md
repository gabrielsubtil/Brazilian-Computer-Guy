# Procedimento Operacional: Limpeza de Disco e Cache (Windows)

**Identificador:** `SOP-WIN-05`  
**Escopo:** Windows 10 e Windows 11.  
**Princípio:** Prévia quantitativa antes de excluir qualquer byte. Preservação incondicional de dados de usuários (`Downloads`, `Documentos`, `Desktop`).

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Verificar espaço total e livre nos volumes
```powershell
Get-Volume | Where-Object DriveType -eq "Fixed" | 
Select-Object DriveLetter, FileSystemLabel, 
              @{Name="Tamanho (GB)"; Expression={[math]::round($_.Size / 1GB, 2)}}, 
              @{Name="Livre (GB)"; Expression={[math]::round($_.SizeRemaining / 1GB, 2)}}, 
              @{Name="% Livre"; Expression={[math]::round(($_.SizeRemaining / $_.Size) * 100, 1)}} | 
Format-Table -AutoSize
```

### B. Medir volume em diretórios temporários e de cache
```powershell
$targets = @(
    "$env:TEMP",
    "C:\Windows\Temp",
    "C:\Windows\SoftwareDistribution\Download"
)

foreach ($path in $targets) {
    if (Test-Path $path) {
        $measure = Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
        $sizeMB = [math]::Round($measure.Sum / 1MB, 2)
        [PSCustomObject]@{ Caminho = $path; Arquivos = $measure.Count; "Tamanho (MB)" = $sizeMB }
    }
} | Format-Table -AutoSize
```

---

## 2. Elaboração da Proposta ao Técnico

Apresente os números reais ao operador antes de qualquer exclusão:

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE LIMPEZA DE DISCO - BCG]**  
> • **Ação:** Exclusão seletiva de arquivos temporários e cache de downloads de atualizações do Windows já instaladas.  
> • **Alvos:**  
>   - `C:\Windows\Temp` (`{TAMANHO_MB}` MB)  
>   - `C:\Windows\SoftwareDistribution\Download` (`{TAMANHO_MB}` MB)  
> • **Motivo:** O disco C: está com espaço livre inferior ao recomendado, impactando a performance de swap e novas atualizações.  
> • **Risco / Impacto:** Nenhum arquivo pessoal ou executável de programa será afetado. O cache do Windows Update será recriado sob demanda.  
> • **Reversão:** Não aplicável a arquivos temporários expirados.  
>  
> *Deseja autorizar a limpeza desses alvos específicos?*

---

## 3. Execução Controlada e Validação

```powershell
# Limpeza de C:\Windows\Temp (arquivos com mais de 7 dias)
Get-ChildItem -Path "C:\Windows\Temp" -Recurse -File -ErrorAction SilentlyContinue | 
Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | 
Remove-Item -Force -ErrorAction SilentlyContinue

# Limpeza de cache de download do Windows Update (SoftwareDistribution\Download)
# Recomenda-se parar o serviço wuauserv antes, limpar e reiniciar
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue
```

### Validação:
Meça novamente o espaço livre na unidade e registre o total de GB liberados no relatório técnico.
