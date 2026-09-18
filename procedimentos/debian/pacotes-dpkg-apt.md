# Procedimento Operacional: Gestão de Pacotes e Repositórios DPKG/APT (Debian)

**Identificador:** `SOP-DEB-05`  
**Escopo:** Debian 11 e 12.  
**Princípio:** Investigar dependências quebradas e repositórios; nunca forçar remoções destrutivas sem aprovação.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Verificar pacotes quebrados ou instalações interrompidas
```bash
dpkg --audit
apt-get check
```

### B. Listar repositórios configurados
```bash
cat /etc/apt/sources.list | grep -v '^#' | grep -v '^$'
ls -la /etc/apt/sources.list.d/
```

### C. Verificar pacotes mantidos ou bloqueados (Held packages)
```bash
apt-mark showhold
```

---

## 2. Elaboração da Proposta ao Técnico

Se houver pacotes com dependências incompletas:

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE CORREÇÃO APT - BCG]**  
> • **Ação:** Executar correção de dependências pendentes (`apt-get install -f`).  
> • **Alvo:** Base de dados do DPKG e pacotes pendentes.  
> • **Motivo:** A última atualização de pacotes foi interrompida, travando o gerenciador de pacotes.  
> • **Risco / Impacto:** O APT baixará as dependências faltantes para concluir a configuração dos pacotes.  
> • **Reversão:** Histórico registrado em `/var/log/dpkg.log`.  
>  
> *Deseja autorizar a correção?*

---

## 3. Execução Controlada e Validação

```bash
# Concluir configurações pendentes
sudo dpkg --configure -a

# Resolver dependências quebradas
sudo apt-get install -f

# Validação:
dpkg --audit
```
A ausência de saída indica que todos os pacotes estão em estado consistente.
