# Procedimento Operacional: Integridade do Sistema e Diagnóstico de Hardware (Windows)

**Identificador:** `SOP-WIN-07`  
**Escopo:** Windows 10 e Windows 11.  
**Princípio:** Primeiro verificar integridade em modo leitura (`/verifyonly`, `CheckHealth`); apenas reparar após consentimento.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Verificar saúde física e SMART dos discos de armazenamento
```powershell
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, OperationalStatus, HealthStatus | Format-Table -AutoSize
Get-PhysicalDisk | Get-StorageReliabilityCounter | Select-Object DeviceId, ReadErrorsTotal, WriteErrorsTotal, Temperature, Wear | Format-Table -AutoSize
```

### B. Diagnóstico do Sistema de Arquivos (CHKDSK somente leitura)
```powershell
# Executa checagem sem parâmetros de modificação (/f ou /r)
chkdsk C:
```

### C. Checagem de integridade da imagem do Windows (DISM)
```powershell
dism /online /cleanup-image /checkhealth
dism /online /cleanup-image /scanhealth
```

### D. Checagem de arquivos de sistema protegidos (SFC modo somente leitura)
```powershell
sfc /verifyonly
```

---

## 2. Elaboração da Proposta ao Técnico

Se o DISM ou SFC apontarem corrupção de componentes:

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE REPARO DE INTEGRIDADE - BCG]**  
> • **Ação:** Executar reparo automático da imagem do Windows e restauração de binários corrompidos.  
> • **Alvo:** Imagem do Windows (`DISM /RestoreHealth`) e arquivos de sistema (`SFC /scannow`).  
> • **Motivo:** A verificação `scanhealth` detectou arquivos essenciais corrompidos que estão causando instabilidade no explorer e crashes.  
> • **Risco / Impacto:** O processo utiliza recursos intensos de CPU e disco por 10 a 20 minutos. Recomenda-se não abrir outros aplicativos pesados durante a execução.  
> • **Reversão:** Ponto de restauração do sistema (caso habilitado).  
>  
> *Deseja autorizar a execução do reparo?*

---

## 3. Execução Controlada e Validação

```powershell
# Reparo da imagem com o Windows Update como fonte oficial
dism /online /cleanup-image /restorehealth

# Reparo e substituição de arquivos corrompidos
sfc /scannow
```

### Validação:
Após o término, execute novamente `sfc /verifyonly` e confirme se a saída é:  
*"A Proteção de Recursos do Windows não encontrou nenhuma violação de integridade."*
Registre os detalhes no relatório final.
