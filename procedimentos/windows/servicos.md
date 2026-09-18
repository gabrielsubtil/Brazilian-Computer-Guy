# Procedimento Operacional: Auditoria e Gerenciamento de Serviços (Windows)

**Identificador:** `SOP-WIN-01`  
**Escopo:** Windows 10, Windows 11 e Windows Server (Legado Windows 8 ver nota).  
**Princípio:** Investigar antes de alterar; intervenção mínima e reversível.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

Antes de propor qualquer modificação em serviços, execute comandos de inspeção sem efeito colateral.

### A. Listar serviços com falha ou parados que deveriam iniciar automaticamente
```powershell
Get-CimInstance -ClassName Win32_Service | 
    Where-Object { $_.StartMode -eq "Auto" -and $_.State -ne "Running" } | 
    Select-Object Name, DisplayName, State, StartMode, ExitCode | 
    Format-Table -AutoSize
```

### B. Inspecionar detalhes, executável e dependências de um serviço suspeito
```powershell
$serviceName = "NOME_DO_SERVICO"
Get-Service -Name $serviceName | Select-Object Name, DisplayName, Status, StartType, DependentServices, ServicesDependedOn | Format-List
Get-CimInstance Win32_Service -Filter "Name='$serviceName'" | Select-Object PathName, StartName, Description | Format-List
```

---

## 2. Elaboração da Proposta ao Técnico

Analise as dependências. Se o serviço for desnecessário ou conflitante, proponha a alteração para modo **Manual** (evite desativar completamente a menos que seja vulnerabilidade crítica comprovada).

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE SERVIÇO - BCG]**  
> • **Ação:** Alterar o tipo de inicialização do serviço.  
> • **Alvo:** Serviço `{NOME_DO_SERVICO}` (`{DISPLAY_NAME}`).  
> • **Configuração Atual:** `{StartMode Atual}` | **Proposta:** `{Manual / Auto}`.  
> • **Motivo:** O serviço está apresentando falha repetitiva no boot e consumindo recursos sem uso ativo pelo usuário.  
> • **Risco / Impacto:** O recurso `{DESCRIÇÃO_DO_RECURSO}` deixará de iniciar automaticamente no boot, sendo acionado sob demanda.  
> • **Reversão:** `Set-Service -Name "{NOME_DO_SERVICO}" -StartupType {StartMode Atual}`.  
>  
> *Deseja autorizar esta alteração?*

---

## 3. Execução Controlada (Somente após aprovação explícita)

```powershell
# Exemplo de ajuste seguro para Manual
Set-Service -Name "NOME_DO_SERVICO" -StartupType Manual
```

Se for necessário reiniciar ou parar o serviço:
```powershell
Stop-Service -Name "NOME_DO_SERVICO" -Force
```

---

## 4. Validação Antes / Depois

Confirme o novo estado do serviço:
```powershell
Get-Service -Name "NOME_DO_SERVICO" | Select-Object Name, Status, StartType
```

---

## 5. Procedimento de Reversão (Rollback)

Para restaurar o estado original:
```powershell
Set-Service -Name "NOME_DO_SERVICO" -StartupType Automatic
Start-Service -Name "NOME_DO_SERVICO"
```
Registre a ação e o resultado no changelog local da máquina.
