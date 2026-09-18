# Procedimento Operacional: Perfil Legado para Windows 8 e 8.1

**Identificador:** `SOP-WIN-LEGACY`  
**Escopo:** Windows 8 e Windows 8.1 (x86 e x64).  
**Princípio:** Adaptação a runtimes legados (PowerShell 4.0 / WMI clássico); não prometer compatibilidade com ferramentas modernas ausentes (ex: Winget, WSL2 moderno).

---

## 1. Particularidades e Limitações do Ambiente Legado

1. **Versão do PowerShell:** Tipicamente PowerShell 4.0 (ou 5.1 se atualizado via WMF). Vários cmdlets modernos de rede e armazenamento não estão disponíveis.
2. **Winget:** Incompatível. O gerenciamento de programas deve recorrer a consultas no Registro ou `wmic product get name,version` (com cautela pelo tempo de execução).
3. **Segurança:** O suporte oficial da Microsoft encerrou-se. Atualizações de sistema dependem de catálogos legados ou pacotes offline `.msu`.

---

## 2. Comandos de Diagnóstico Adaptados para Windows 8

### A. Diagnóstico de Serviços (Alternativa compatível com PS 4.0 / sc.exe)
```powershell
Get-WmiObject -Class Win32_Service | 
Where-Object { $_.StartMode -eq "Auto" -and $_.State -ne "Running" } | 
Select-Object Name, DisplayName, State, StartMode | Format-Table -AutoSize
```

### B. Diagnóstico de Conexões e Portas (Alternativa via netstat clássico)
```cmd
netstat -ano | findstr /i "LISTENING"
```

### C. Consulta de Discos e Partições
```powershell
Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | 
Select-Object DeviceId, VolumeName, 
              @{Name="Tamanho(GB)"; Expression={[math]::round($_.Size/1GB,2)}}, 
              @{Name="Livre(GB)"; Expression={[math]::round($_.FreeSpace/1GB,2)}} | 
Format-Table -AutoSize
```

---

## 3. Diretrizes de Suporte no BCG
- Ao atender uma máquina com Windows 8, identifique a versão logo no início da sessão e anote explicitamente em `.local/<nome-da-maquina>/memory.md`.
- Oriente o cliente/técnico sobre as vulnerabilidades inerentes ao fim do ciclo de suporte oficial.
