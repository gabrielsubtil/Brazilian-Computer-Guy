# Procedimento Operacional: Diagnóstico de Portas e Conexões Ativas

**Identificador:** `SOP-NET-03`  
**Escopo:** Windows 10/11, Debian 11/12.  
**Princípio:** Auditoria de segurança de rede e portas abertas locais; somente leitura.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Windows (PowerShell)
```powershell
# 1. Listar portas TCP em escuta (Listening) com nome do processo
Get-NetTCPConnection -State Listen | 
Select-Object LocalAddress, LocalPort, OwningProcess, 
              @{Name="Processo"; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}} | 
Format-Table -AutoSize

# 2. Testar se uma porta específica de um servidor remoto está acessível
Test-NetConnection -ComputerName "exemplo.com.br" -Port 443
```

### B. Debian (Bash)
```bash
# 1. Listar portas TCP e UDP em escuta com processo
sudo ss -tulpn | grep LISTEN

# 2. Listar conexões estabelecidas ativas
ss -tupn state established
```

---

## 2. Interpretação Técnica

- **Portas suspeitas abertas em `0.0.0.0`:** Investigar se o processo é legítimo ou se deve ter seu bind restrito a `127.0.0.1` (localhost).
- **Conexões externas anômalas:** Verificar o IP de destino via GeoIP/Whois ou `mcp-nettools` para descartar malwares ou botnets.
- Documente as portas ativas no relatório de segurança.
