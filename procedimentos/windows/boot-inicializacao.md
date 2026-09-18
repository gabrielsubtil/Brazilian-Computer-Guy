# Procedimento Operacional: Diagnóstico de Boot e Inicialização (Windows)

**Identificador:** `SOP-WIN-04`  
**Escopo:** Windows 10 e Windows 11.  
**Princípio:** Investigar gargalos de inicialização sem remover entradas à força; intervenção mínima, reversível e autorizada.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Listar aplicativos na pasta Inicializar e chaves Run do Registro
```powershell
# Chaves Run (Usuário e Máquina)
Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run", 
                       "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue |
Select-Object PSChildName, * -ExcludeProperty PS*

# Aplicativos da pasta Startup
Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup", 
                    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" -ErrorAction SilentlyContinue |
Select-Object Name, FullName
```

### B. Listar tarefas agendadas que disparam no logon
```powershell
Get-ScheduledTask | 
Where-Object { $_.Triggers.CimClass.CimClassName -match "Logon|Boot" -and $_.State -ne "Disabled" } | 
Select-Object TaskName, TaskPath, State | Format-Table -AutoSize
```

### C. Inspecionar configuração do BCD (somente leitura)
```cmd
bcdedit /enum {current}
```

---

## 2. Elaboração da Proposta ao Técnico

Se um aplicativo de terceiros (ex: atualizadores constantes, programas de inicialização não essenciais) estiver impactando gravemente o tempo de boot:

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE INICIALIZAÇÃO - BCG]**  
> • **Ação:** Desativar a tarefa agendada ou entrada de inicialização do programa `{NOME_DO_PROGRAMA}`.  
> • **Alvo:** `{Nome da Tarefa ou Chave do Registro}`.  
> • **Motivo:** O programa inicia com o Windows consumindo memória e disco, mas é usado raramente pelo usuário.  
> • **Risco / Impacto:** O programa continuará funcionando normalmente quando aberto manualmente, mas não abrirá sozinho ao ligar o PC.  
> • **Reversão:** `Enable-ScheduledTask -TaskName "{NOME_DA_TAREFA}"`.  
>  
> *Deseja autorizar a desativação?*

---

## 3. Execução Controlada e Validação

```powershell
# Desativação segura de tarefa agendada (sem deletar)
Disable-ScheduledTask -TaskName "NOME_DA_TAREFA"

# Validação:
Get-ScheduledTask -TaskName "NOME_DA_TAREFA" | Select-Object TaskName, State
```
