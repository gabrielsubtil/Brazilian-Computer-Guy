# Procedimento Operacional: Gestão de Programas e Aplicativos (Windows)

**Identificador:** `SOP-WIN-06`  
**Escopo:** Windows 10 e Windows 11.  
**Princípio:** Identificar nome, versão e origem do software; nunca desinstalar por iniciativa própria; verificar o resultado pós-remoção.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Listar programas instalados via Winget
```powershell
winget list
```

### B. Listar programas instalados via Registro (Win32 clássicos)
```powershell
$uninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

Get-ItemProperty $uninstallKeys -ErrorAction SilentlyContinue | 
Where-Object { $_.DisplayName -and $_.UninstallString } | 
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | 
Sort-Object DisplayName | Format-Table -AutoSize
```

---

## 2. Elaboração da Proposta ao Técnico

Se um programa for identificado como bloatware, conflitante ou corrompido:

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE DESINSTALAÇÃO - BCG]**  
> • **Ação:** Desinstalar o software `{NOME_DO_PROGRAMA}`.  
> • **Alvo:** Versão `{VERSAO}` (Editor: `{PUBLISHER}`).  
> • **Motivo:** O programa foi descontinuado pelo fabricante e está gerando falhas no logon e incompatibilidade de drivers.  
> • **Risco / Impacto:** As funcionalidades associadas a este programa deixarão de estar disponíveis.  
> • **Reversão:** Reinstalação manual através do instalador oficial ou via `winget install {ID}`.  
>  
> *Deseja autorizar a desinstalação?*

---

## 3. Execução Controlada e Validação

```powershell
# Exemplo de desinstalação via Winget
winget uninstall --id "ID_DO_PACOTE" --silent

# Validação:
winget list --id "ID_DO_PACOTE"
```
Confirme se o pacote não é mais retornado na lista e registre no changelog.
