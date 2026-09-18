# Procedimento Operacional: Limpeza de Disco e Cache APT (Debian)

**Identificador:** `SOP-DEB-04`  
**Escopo:** Debian 11 e 12.  
**Princípio:** Prévia de espaço antes de qualquer remoção; preservação integral de dados de usuários em `/home`.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Verificar espaço livre e inodes em todos os pontos de montagem
```bash
df -h
df -i
```

### B. Medir tamanho do cache de pacotes baixados pelo APT
```bash
du -sh /var/cache/apt/archives 2>/dev/null
```

### C. Medir tamanho ocupado pelos logs do sistema (Journald)
```bash
journalctl --disk-usage
```

### D. Simular remoção de pacotes órfãos sem executar (Dry-Run)
```bash
apt-get autoremove --dry-run
```

---

## 2. Elaboração da Proposta ao Técnico

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE LIMPEZA DE DISCO DEBIAN - BCG]**  
> • **Ação:** Limpar cache de pacotes `.deb` já instalados (`apt-get clean`) e limitar logs do journald a 200MB.  
> • **Alvos:** `/var/cache/apt/archives` e `/var/log/journal`.  
> • **Motivo:** O diretório raiz `/` atingiu 88% de ocupação, colocando em risco a escrita de logs e bases de dados.  
> • **Risco / Impacto:** Nenhum pacote instalado será removido; apenas os instaladores em cache e logs arquivados antigos serão liberados.  
> • **Reversão:** Pacotes futuros serão baixados novamente dos repositórios sob demanda.  
>  
> *Deseja autorizar a limpeza desses alvos?*

---

## 3. Execução Controlada e Validação

```bash
# Limpeza de cache de pacotes
sudo apt-get clean

# Limpeza de logs antigos mantendo os últimos 7 dias
sudo journalctl --vacuum-time=7d

# Validação:
df -h /
```
Registre o espaço em GB recuperado no changelog da máquina e no relatório.
