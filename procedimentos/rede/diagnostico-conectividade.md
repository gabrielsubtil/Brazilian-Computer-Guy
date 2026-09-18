# Procedimento Operacional: Diagnóstico de Conectividade de Rede

**Identificador:** `SOP-NET-01`  
**Escopo:** Windows 10/11, Debian 11/12.  
**Princípio:** Diagnóstico complementar em modo somente leitura; testar passo a passo (Loopback -> Gateway -> DNS -> Internet).

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Windows (PowerShell)
```powershell
# 1. Testar pilha TCP/IP local (Loopback)
Test-Connection -ComputerName 127.0.0.1 -Count 2

# 2. Obter IP do Gateway padrão
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0").NextHop
Write-Host "Gateway Padrão: $gateway"

# 3. Testar conectividade com o Gateway
Test-Connection -ComputerName $gateway -Count 4

# 4. Testar conectividade com a Internet (DNS público)
Test-Connection -ComputerName 1.1.1.1 -Count 4

# 5. Rastrear rota de pacotes (Traceroute)
Test-NetConnection -ComputerName 1.1.1.1 -TraceRoute
```

### B. Debian (Bash)
```bash
# 1. Testar loopback
ping -c 2 127.0.0.1

# 2. Obter gateway e testar
GATEWAY=$(ip route | grep default | awk '{print $3}')
ping -c 4 "$GATEWAY"

# 3. Testar internet externa
ping -c 4 1.1.1.1

# 4. Rastreamento de rota
traceroute 1.1.1.1 2>/dev/null || tracepath 1.1.1.1
```

---

## 2. Interpretação Técnica

- **Falha no Loopback:** Pilha de rede corrompida no SO.
- **Falha no Gateway:** Cabo desconectado, Wi-Fi sem autenticação ou problema no roteador local.
- **Gateway responde, mas 1.1.1.1 falha:** Conexão com o provedor de internet (ISP) interrompida ou bloqueio em firewall perimetral.
- Documente latência e perda percentual no relatório técnico.
