# Brazilian Computer Guy (BCG) 🛠️🇧🇷

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Debian-lightgrey.svg)](docs/matrix-compatibility.md)
[![Agents](https://img.shields.io/badge/AI%20Agents-VS%20Code%20%7C%20Copilot%20%7C%20Antigravity%20%7C%20Claude%20%7C%20OpenCode-blueviolet.svg)](docs/architecture.md)

**Idiomas / Languages:**  
🇧🇷 **Português (Brasil)** | [🇺🇸 English](README.en.md)

---

> **O canivete suíço de TI para técnicos de informática em ambientes de IA.**  
> Diagnóstico avançado, procedimentos operacionais seguros, respeito absoluto à privacidade e geração estruturada de relatórios de atendimento.

---

## 💡 Sobre o Projeto

O **Brazilian Computer Guy (BCG)** foi criado para capacitar técnicos de suporte e administradores de sistemas a realizar manutenções guiadas de alta precisão diretamente em seus ambientes de desenvolvimento com IA (com foco nativo em **VS Code**, além de suporte total a **Antigravity IDE**, **Claude Code**, **OpenCode** e **Codex**).

O agente atua com a mentalidade de um técnico brasileiro veterano: criativo para investigar causas raízes, didático nas explicações e extremamente prudente, **nunca realizando qualquer alteração no computador sem a autorização explícita do operador humano**.

---

## 🚀 Principais Capacidades

- 🔍 **Diagnóstico Somente Leitura:** Coleta de evidências em profundidade sem riscos de instabilidade ou perda de dados.
- 🛡️ **Segurança e Autorização Explícita:** Apresenta comando, alvo, efeito e plano de reversão antes de qualquer alteração de estado.
- 📋 **Relatórios Técnicos Obrigatórios:** Cada intervenção ou diagnóstico gera automaticamente um relatório completo e profissional pronto para arquivamento ou envio ao cliente final.
- 🧠 **Memória e Histórico por Máquina:** Armazena o perfil de cada computador em `.local/<nome-da-maquina>/` de forma sanitizada e isolada do Git.
- 🌐 **Catálogo de Procedimentos (SOPs):** Procedimentos testados e parametrizados para Windows (8/10/11), Debian e diagnósticos complementares de rede.
- 🔌 **Ecossistema MCP:** Integração nativa com **Microsoft Learn MCP**, ferramentas de diagnóstico de rede (**mcp-nettools**) e utilitários de administração.

---

## 📁 Estrutura do Repositório

```text
Brazilian-Computer-Guy/
├── agent.md                      # Regras centrais, pipelines e governança
├── soul.md                       # Personalidade do técnico brasileiro prudente
├── geminai.md                    # Adaptador Gemini AI; gatilhos e regras de segurança
├── README.md                     # Este manual
├── LICENSE                       # Licença MIT
├── package.json                  # Manifesto e utilitários
├── .gitignore                    # Bloqueio estrito de persistência e dados locais
│
├── .github/                      # Adaptador para GitHub Copilot no VS Code
│   └── copilot-instructions.md
├── .vscode/                      # Configurações de MCP e workspace do VS Code
│   ├── mcp.json
│   └── settings.json
├── .agents/                      # Adaptador para Antigravity IDE
│   ├── rules/brazilian-computer-guy.md
│   └── mcp_config.json
├── CLAUDE.md                     # Adaptador raiz para Claude Code
├── .mcp.json                     # Configuração MCP para Claude Code
├── AGENTS.md                     # Adaptador para OpenCode e Codex
├── opencode.json                 # Configuração para OpenCode
├── .codex/                       # Configuração para OpenAI Codex
│   └── config.toml
│
├── templates/                    # Modelos limpos de persistência e relatórios
│   ├── report-template.md        # Modelo oficial de Relatório Técnico de Atendimento
│   ├── memory-template.md        # Modelo de histórico e hardware por máquina
│   ├── changelog-template.md     # Modelo de auditoria de alterações e rollback
│   └── session-summary-template.md
│
├── procedimentos/                # Guias Operacionais Padronizados (SOPs)
│   ├── windows/                  # Serviços, Event Log, Energia, Boot, Limpeza, etc.
│   ├── debian/                   # Systemd, Journald, GRUB, APT, Pacotes
│   └── rede/                     # Conectividade, DNS, Portas e Rotas
│
├── pipelines/                    # Fluxos de diagnóstico e intervenção autorizada
│   └── reducao-de-processos-windows.md
│
├── tools/                        # Scripts utilitários de diagnóstico e automação
│   ├── windows/                  # Get-SystemDiagnostic.ps1, Test-NetworkHealth.ps1
│   ├── debian/                   # system_diagnostic.sh, network_health.sh
│   └── reporting/                # generate-report.js (compilador de relatórios)
│
├── docs/                         # Documentação técnica e matriz de compatibilidade
│   ├── architecture.md           # Arquitetura e fluxo de atendimento
│   ├── security-and-permissions.md # Diretrizes de segurança e opt-in
│   ├── matrix-compatibility.md   # Matriz SO x Clientes de IA x Ferramentas
│   ├── licenses.md               # Atribuição e licenças de componentes
│   └── releases.md               # Histórico de versões
│
└── vendor/                       # Catálogo de MCPs homologados e integrações
    └── README.md
```

---

## 💻 Como Começar no VS Code

1. Clone o repositório em uma pasta local:

   ```bash
   git clone https://github.com/gabrielsubtil/Brazilian-Computer-Guy.git
   cd Brazilian-Computer-Guy
   ```

2. Abra o projeto no **VS Code**:

   ```bash
   code .
   ```

3. Inicie uma conversa com seu agente de IA (ex: **GitHub Copilot Chat** no modo Agent, Claude Code ou Antigravity).
4. O agente lerá automaticamente [`agent.md`](./agent.md) e [`soul.md`](./soul.md).
5. Informe o nome ou identificador da máquina a ser atendida (ex: `PC-LAB-01`) e relate o sintoma ou necessidade.
6. Acompanhe o diagnóstico, autorize pontualmente os procedimentos recomendados e receba o relatório ao final!

---

## 📊 Geração de Relatórios Técnicos

Toda ação de diagnóstico ou manutenção gera um relatório final estruturado. Você pode compilar um relatório a qualquer momento executando:

```bash
npm run report -- --machine="NOME_DA_MAQUINA"
```

Ou solicitando diretamente ao agente: *"Gere o relatório final de atendimento deste computador"*.

O documento gerado segue as normas profissionais de atendimento técnico de informática, pronto para ser entregue ao cliente ou arquivado em chamados.

---

## 📄 Licença

Distribuído sob a licença **MIT**. Veja [`LICENSE`](./LICENSE) para mais detalhes.
