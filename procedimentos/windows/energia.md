# Procedimento Operacional: Diagnóstico e Configuração de Energia (Windows)

**Identificador:** `SOP-WIN-03`  
**Escopo:** Windows 10 e Windows 11 (Desktops e Notebooks).  
**Princípio:** Investigar plano ativo, dispositivos de despertar e problemas de suspensão; alterar somente com autorização explícita.

---

## 1. Coleta e Diagnóstico Inicial (Somente Leitura)

### A. Listar planos de energia disponíveis e o plano ativo
```powershell
powercfg /list
```

### B. Descobrir o motivo do último despertar do computador
```powershell
powercfg /lastwake
```

### C. Listar dispositivos de hardware com permissão para acordar o sistema (mouses, placas de rede)
```powershell
powercfg /devicequery wake_armed
```

### D. Gerar relatório de eficiência e integridade energética (somente leitura)
```powershell
# Gera diagnóstico para análise sem modificar o sistema
powercfg /energy /duration 10 /output "$env:TEMP\energy_report.html"
```

---

## 2. Elaboração da Proposta ao Técnico

Problemas comuns de energia:
1. **Despertar involuntário durante a noite:** Causado frequentemente por adaptadores de rede com "Wake on LAN" ativo ou mouse sensível.
2. **Falhas ao desligar / travamento no boot (Fast Startup):** O recurso de Inicialização Rápida (`Hiberboot`) pode causar desincronização de drivers em máquinas mais antigas.

### Formato Obrigatório de Pedido de Autorização:
> **[PROPOSTA DE ENERGIA - BCG]**  
> • **Ação:** Desativar a permissão de despertar do dispositivo `{NOME_DO_DISPOSITIVO}` ou desativar Fast Startup.  
> • **Alvo:** `{Dispositivo / Registro HiberbootEnabled}`.  
> • **Motivo:** O computador está ligando sozinho no meio da madrugada devido a eventos de rede/mouse.  
> • **Risco / Impacto:** O dispositivo em questão não poderá mais tirar o computador da suspensão; apenas o teclado/botão power fará isso.  
> • **Reversão:** Reativar permissão com `powercfg /deviceenablewake "{NOME_DO_DISPOSITIVO}"`.  
>  
> *Deseja autorizar esta alteração?*

---

## 3. Execução Controlada e Validação

```powershell
# Exemplo: Desarmar dispositivo que acorda o computador indevidamente
powercfg /devicedisablewake "NOME_DO_DISPOSITIVO"

# Validação:
powercfg /devicequery wake_armed
```
