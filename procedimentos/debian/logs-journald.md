# Procedimento Operacional: Análise de Logs com Journald e Syslog (Debian)

**Identificador:** `SOP-DEB-02`  
**Escopo:** Debian 11, Debian 12.  
**Princípio:** Preservação estrita dos logs do sistema. Não esvaziar `/var/log` sem autorização formal de arquivamento.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Listar erros e alertas críticos do boot atual
```bash
journalctl -b 0 -p err..emerg --no-pager -n 40
```

### B. Inspecionar logs de um serviço específico nas últimas 2 horas
```bash
journalctl -u nome-do-servico --since "2 hours ago" --no-pager
```

### C. Verificar mensagens de hardware e drivers no Kernel (dmesg com data/hora legível)
```bash
dmesg -T -l err,crit,alert,emerg
```

### D. Checar falhas de autenticação e acessos negados (segurança)
```bash
grep -i "failed" /var/log/auth.log 2>/dev/null | tail -n 20
```

---

## 2. Diagnóstico e Correlação

1. Correlacione erros de hardware (`I/O error`, `EXT4-fs error`) com a integridade física de discos (usando `smartctl -a /dev/sdX`).
2. Verifique se falhas de serviço decorrem de permissões (`Permission denied`), portas em conflito (`Address already in use`) ou memória insuficiente (`Out of memory / OOM Killer`).
3. Documente os logs relevantes no relatório final sem expor senhas ou tokens que possam estar presentes nos logs.
