# Arquitetura do Brazilian Computer Guy (BCG)

Este documento detalha o modelo arquitetural, o ciclo de vida de um atendimento técnico e as fronteiras de isolamento de dados do **Brazilian Computer Guy**.

---

## 1. Visão Geral da Arquitetura

O BCG foi projetado sobre uma arquitetura desacoplada e modular, composta por 4 camadas essenciais:

```mermaid
flowchart TB
    subgraph Camada1["1. Camada de Adaptadores de IA (Host)"]
        VS["VS Code / Copilot"]
        AG["Antigravity IDE"]
        CC["Claude Code"]
        OP["OpenCode / Codex"]
    end

    subgraph Camada2["2. Núcleo de Governança & Persona"]
        AGM["agent.md (Orquestrador Central)"]
        SOUL["soul.md (Persona Técnica)"]
    end

    subgraph Camada3["3. Camada Operacional & SOPs"]
        SOP_WIN["procedimentos/windows/"]
        SOP_DEB["procedimentos/debian/"]
        SOP_NET["procedimentos/rede/"]
        MCP["Servidores MCP (Learn / NetTools)"]
        TOOLS["Scripts Nativos (tools/)"]
    end

    subgraph Camada4["4. Camada de Persistência & Auditoria"]
        MEM[".local/<maquina>/memory.md"]
        CHG[".local/<maquina>/changelog.md"]
        REP["relatorios/ (Relatório Final)"]
    end

    Camada1 --> Camada2
    Camada2 --> Camada3
    Camada3 --> Camada4
```

---

## 2. Isolamento de Dados e Privacidade

1. **Repositório Template Neutro:**
   - O repositório distribuído no GitHub é totalmente agnóstico e isento de logs, caminhos ou históricos da máquina do desenvolvedor.
2. **Persistência Volátil e Isolada:**
   - Quando um computador é atendido, o agente instancia a pasta `.local/<nome-da-maquina>/`.
   - Essa pasta é ignorada pelo `.gitignore` e pertence exclusivamente à máquina atendida.
3. **Não Exposição de Segredos:**
   - O agente nunca transmite variáveis de ambiente sensíveis (`.env`), senhas ou tokens aos modelos de IA ou consultas documentais.

---

## 3. O Ciclo de Vida do Atendimento Técnico

Todo atendimento executado pelo BCG segue 6 fases bem delimitadas:
1. **Identificação do Ambiente:** Detecção de SO, versão, hostname e leitura da memória local prévia.
2. **Diagnóstico Somente Leitura:** Coleta de evidências usando SOPs e scripts sem alteração de estado.
3. **Proposta Técnica e Hipótese:** Formulação da causa raiz e proposta com comando exato e reversão.
4. **Consentimento Explícito (Opt-in):** Parada obrigatória aguardando aprovação explícita do técnico.
5. **Execução & Validação:** Aplicação do procedimento autorizado e teste antes/depois.
6. **Emissão de Relatório:** Geração do Relatório Técnico de Atendimento oficial para entrega e histórico.
