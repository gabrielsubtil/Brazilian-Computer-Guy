# Procedimento Operacional: Diagnóstico e Resolução DNS

**Identificador:** `SOP-NET-02`  
**Escopo:** Windows 10/11, Debian 11/12.  
**Princípio:** Comparar resolução do servidor configurado com resolvers públicos; flushing de cache somente após autorização.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Windows (PowerShell)
```powershell
# 1. Identificar servidores DNS configurados nos adaptadores
Get-DnsClientServerAddress -AddressFamily IPv4 | Format-Table -AutoSize

# 2. Testar resolução via DNS configurado no sistema
Resolve-DnsName -Name "microsoft.com"

# 3. Testar resolução direta apontando para DNS público alternativo (Cloudflare / Google)
Resolve-DnsName -Name "microsoft.com" -Server 1.1.1.1
```

### B. Debian (Bash)
```bash
# 1. Identificar servidores DNS
cat /etc/resolv.conf | grep nameserver

# 2. Testar resolução do sistema
getent hosts debian.org

# 3. Testar resolução via dig contra servidor específico
dig @1.1.1.1 debian.org +short
```

---

## 2. Elaboração da Proposta ao Técnico

Se houver cache DNS envenenado ou desatualizado:

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE AJUSTE DNS - BCG]**  
> • **Ação:** Limpar o cache local do cliente DNS.  
> • **Alvo:** Cache do resolvedor DNS do sistema operacional.  
> • **Motivo:** O domínio não resolve localmente devido a um registro expirado em cache.  
> • **Risco / Impacto:** As próximas requisições farão nova consulta ao servidor DNS configurado (latência mínima imperceptível).  
> • **Reversão:** Não aplicável (o cache é recriado dinamicamente).  
>  
> *Deseja autorizar a limpeza do cache DNS?*

---

## 3. Execução Controlada e Validação

```powershell
# Windows:
Clear-DnsClientCache

# Debian:
sudo systemd-resolve --flush-caches 2>/dev/null || sudo resolvectl flush-caches
```

### Validação:
Teste novamente a resolução do domínio problemático e anote o IP retornado no relatório.
