# Procedimento Operacional: Diagnóstico de Boot e GRUB (Debian)

**Identificador:** `SOP-DEB-03`  
**Escopo:** Debian 11 e 12 (Sistemas UEFI e BIOS legada).  
**Princípio:** Diagnosticar gargalos de inicialização com segurança; reparos no GRUB exigem backup prévio e consentimento estrito.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Tempo total gasto no processo de boot (Kernel vs Userspace)
```bash
systemd-analyze
```

### B. Listar os serviços que mais atrasaram a inicialização (Blame)
```bash
systemd-analyze blame | head -n 15
```

### C. Mapear a cadeia crítica de inicialização (Critical Chain)
```bash
systemd-analyze critical-chain
```

### D. Inspecionar a configuração do GRUB (Somente leitura)
```bash
cat /etc/default/grub | grep -v '^#' | grep -v '^$'
```

---

## 2. Elaboração da Proposta ao Técnico

Se um serviço não essencial estiver travando a inicialização (ex: busca por rede inexistente):

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE BOOT DEBIAN - BCG]**  
> • **Ação:** Desativar a espera de rede `systemd-networkd-wait-online.service` no boot.  
> • **Alvo:** `/etc/systemd/system/network-online.target.wants/`  
> • **Motivo:** O serviço está adicionando 1m 45s ao tempo de boot aguardando interfaces desconectadas.  
> • **Risco / Impacto:** O boot será cerca de 100 segundos mais rápido; serviços que dependem de rede externa aguardarão a conexão ser estabelecida dinamicamente.  
> • **Reversão:** `sudo systemctl enable systemd-networkd-wait-online.service`.  
>  
> *Deseja autorizar esta alteração?*

---

## 3. Execução Controlada e Validação

```bash
sudo systemctl disable systemd-networkd-wait-online.service

# Validação:
systemctl is-enabled systemd-networkd-wait-online.service
```
