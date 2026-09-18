# Procedimento Operacional: Diagnóstico de Interfaces e Roteamento

**Identificador:** `SOP-NET-04`  
**Escopo:** Windows 10/11, Debian 11/12.  
**Princípio:** Investigar status físico do enlace, MTU, DHCP e tabelas de roteamento em modo somente leitura.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Windows (PowerShell)
```powershell
# 1. Informações completas de IP, Gateway e DNS
Get-NetIPConfiguration | Format-List InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer

# 2. Status físico do adaptador de rede, velocidade de link e status operacional
Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, LinkSpeed, MacAddress | Format-Table -AutoSize

# 3. Tabela de rotas IPv4
Get-NetRoute -AddressFamily IPv4 | Select-Object DestinationPrefix, NextHop, RouteMetric, InterfaceAlias | Format-Table -AutoSize
```

### B. Debian (Bash)
```bash
# 1. Endereçamento e estado das interfaces
ip -br addr show

# 2. Tabela de rotas
ip route show

# 3. Estatísticas de pacotes e erros por interface
ip -s link
```

---

## 2. Diagnóstico de Problemas Comuns
- **LinkSpeed abaixo do esperado (ex: 100 Mbps em porta Gigabit):** Cabo de rede danificado (par rompido) ou conector RJ45 oxidado.
- **Múltiplos Gateways padrão com mesma métrica:** Causa oscilação de tráfego e quedas aleatórias de chamadas de voz/vídeo.
- Documente a topologia detectada no relatório técnico.
