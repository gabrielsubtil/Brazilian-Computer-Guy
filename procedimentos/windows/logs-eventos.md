# Procedimento Operacional: Análise de Event Viewer e Logs de Erro (Windows)

**Identificador:** `SOP-WIN-02`  
**Escopo:** Windows 10, Windows 11 e Windows Server.  
**Princípio:** Preservação estrita de logs. Nunca limpar o visualizador de eventos sem solicitação formal; investigar e correlacionar causas raízes.

---

## 1. Coleta Inicial e Diagnóstico (Somente Leitura)

### A. Obter os erros críticos das últimas 24 a 48 horas (System e Application)
```powershell
Get-WinEvent -FilterHashtable @{
    LogName = 'System', 'Application'
    Level = 1, 2 # 1 = Critical, 2 = Error
    StartTime = (Get-Date).AddDays(-2)
} -MaxEvents 30 | 
Select-Object TimeCreated, LogName, ProviderName, Id, Message | 
Format-Table -Wrap
```

### B. Investigação de Desligamentos Inesperados e Telas Azuis (BSOD)
- **Evento ID 41 (Kernel-Power):** Indica reinício sem desligamento limpo.
- **Evento ID 1001 (BugCheck):** Contém código STOP e parâmetros da BSOD.
```powershell
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    Id = 41, 1001
} -MaxEvents 5 -ErrorAction SilentlyContinue | 
Select-Object TimeCreated, Id, Message | Format-List
```

### C. Verificar localização de arquivos de despejo de memória (Minidump)
```powershell
Get-ChildItem -Path "C:\Windows\Minidump" -Filter "*.dmp" -ErrorAction SilentlyContinue | 
Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
```

---

## 2. Interpretação e Correlação

1. Separe **evidência direta** (código de erro e DLL causadora) de **hipótese** (driver instável ou falha de hardware).
2. Consulte documentação oficial pelo **Microsoft Learn MCP** antes de recomendar substituição de bibliotecas ou alterações profundas.
3. Se o erro apontar para um driver de terceiros, identifique a versão instalada antes de propor atualização.

---

## 3. Preservação e Auditoria

- **Regra de Ouro:** Não execute `wevtutil cl` ou "limpar logs do sistema". O histórico de eventos é o histórico clínico do equipamento e protege o técnico e o cliente.
- Ao gerar o **Relatório Técnico de Atendimento**, transcreva os códigos de evento exatos encontrados e sua resolução.
