# Procedimento Operacional: Gerenciamento de Serviços Systemd (Debian)

**Identificador:** `SOP-DEB-01`  
**Escopo:** Debian 11 (Bullseye), Debian 12 (Bookworm) e derivados estáveis.  
**Princípio:** Investigar unidades com falha e dependências; não mascarar ou desabilitar serviços sem plano detalhado e reversível.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Listar unidades do systemd em estado de falha (Failed)
```bash
systemctl --failed --type=service
```

### B. Inspecionar status detalhado, processo e logs recentes de um serviço
```bash
SERVICE_NAME="nome-do-servico"
systemctl status "$SERVICE_NAME"
```

### C. Verificar se o serviço está habilitado para o boot
```bash
systemctl is-enabled "$SERVICE_NAME"
```

### D. Checar dependências da unidade
```bash
systemctl list-dependencies "$SERVICE_NAME" --all
```

---

## 2. Elaboração da Proposta ao Técnico

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE SERVIÇO DEBIAN - BCG]**  
> • **Ação:** Reiniciar ou desabilitar a unidade do systemd `{SERVICE_NAME}.service`.  
> • **Alvo:** `/etc/systemd/system/` ou `/lib/systemd/system/{SERVICE_NAME}.service`.  
> • **Motivo:** O serviço crashou com código de erro `{EXIT_CODE}` e está bloqueando a inicialização de outros daemons.  
> • **Risco / Impacto:** O serviço `{SERVICE_NAME}` ficará temporariamente inacessível durante a reinicialização ou não subirá no próximo boot.  
> • **Reversão:** `sudo systemctl enable --now {SERVICE_NAME}`.  
>  
> *Deseja autorizar a intervenção?*

---

## 3. Execução Controlada e Validação

```bash
# Reiniciar unidade após autorização
sudo systemctl restart "$SERVICE_NAME"

# Validação:
systemctl is-active "$SERVICE_NAME"
```
Registre o resultado no changelog da máquina.
