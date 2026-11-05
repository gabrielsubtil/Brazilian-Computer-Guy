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
- 🖱️ **Operação de Interface Gráfica (Computer Use):** Lê a árvore de acessibilidade do sistema (UI Automation no Windows, AT-SPI no Linux) para diagnosticar e operar aplicativos que não têm linha de comando — por referência de elemento, sem automação por pixel e sem roubar o foco do usuário. Construído sobre o [`agent-desktop`](https://github.com/vercel-labs/agent-desktop) do Vercel Labs, com a governança do BCG aplicada comando por comando. Detalhes em [`docs/computer-use.md`](./docs/computer-use.md).
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
├── CREDITS.md                    # Créditos, autoria e atribuições de terceiros
├── LICENSE                       # Licença MIT
├── package.json                  # Manifesto e utilitários
├── .gitignore                    # Bloqueio estrito de persistência e dados locais
│
├── .github/                      # Adaptador Copilot, templates de issue e CI
│   ├── copilot-instructions.md
│   ├── release.yml               # Agrupamento das notas de release
│   ├── ISSUE_TEMPLATE/           # Relato de problema e proposta de SOP
│   └── workflows/validate.yml    # Valida estrutura, scripts e links internos
│
├── assets/                       # Imagem de compartilhamento (social preview)
│   ├── social-preview.svg
│   └── social-preview.png
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
│   ├── rede/                     # Conectividade, DNS, Portas e Rotas
│   └── computer-use/             # Instalação, laço de GUI e diagnóstico por acessibilidade
│
├── pipelines/                    # Fluxos de diagnóstico e intervenção autorizada
│   ├── README.md                 # Formato, selo e checklist de pipelines
│   ├── reducao-de-processos-windows.md
│   └── otimizacao-registro-windows.md
│
├── tools/                        # Scripts utilitários de diagnóstico e automação
│   ├── windows/                  # Get-SystemDiagnostic.ps1, Test-NetworkHealth.ps1
│   ├── debian/                   # system_diagnostic.sh, network_health.sh
│   ├── computer-use/             # check_agent_desktop.sh, Check-AgentDesktop.ps1
│   └── reporting/                # generate-report.js (compilador de relatórios)
│
├── docs/                         # Documentação técnica e matriz de compatibilidade
│   ├── architecture.md           # Arquitetura e fluxo de atendimento
│   ├── computer-use.md           # Camada de operação GUI: classes de comando e limites
│   ├── security-and-permissions.md # Diretrizes de segurança e opt-in
│   ├── matrix-compatibility.md   # Matriz SO x Clientes de IA x Ferramentas
│   ├── licenses.md               # Atribuição e licenças de componentes
│   └── releases.md               # Histórico de versões
│
└── vendor/                       # Catálogo de MCPs homologados e integrações
    ├── README.md
    └── agent-desktop/            # Registro de integração (Vercel Labs, Apache-2.0)
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

## 🖱️ Computer Use (Operação de Interface Gráfica)

Alguns problemas só existem na tela: um instalador que falha em um diálogo, um aplicativo legado sem CLI, um painel que não tem equivalente por linha de comando. Para esses casos, o BCG tem uma camada de operação de GUI construída sobre o [`agent-desktop`](https://github.com/vercel-labs/agent-desktop) (**Vercel Labs**, licença **Apache-2.0**), que lê a árvore de acessibilidade do sistema em vez de "adivinhar" por pixel.

```bash
# 1. Instalar (Node.js 18+). No macOS/Linux, também: brew install agent-desktop
npm install -g agent-desktop

# 2. Verificar a instalação e as permissões (somente leitura)
bash tools/computer-use/check_agent_desktop.sh        # Linux/macOS
# powershell -ExecutionPolicy Bypass -File .\tools\computer-use\Check-AgentDesktop.ps1   # Windows

# 3. Pré-voo obrigatório
agent-desktop status
agent-desktop permissions
```

A governança **não muda**: comandos de observação (`snapshot`, `find`, `get`, `is`, `list-*`) rodam livremente; qualquer comando que altere estado (`click`, `type`, `set-value`, `launch`, `close-app`…) exige a mesma Proposta de Intervenção do `agent.md`. UAC, tela de login, 2FA, senhas e dados financeiros são proibidos em qualquer hipótese.

| Recurso | Link |
|---|---|
| Arquitetura, classes A/B/C e limites | [`docs/computer-use.md`](./docs/computer-use.md) |
| Instalação e verificação | [`procedimentos/computer-use/instalacao-e-verificacao.md`](./procedimentos/computer-use/instalacao-e-verificacao.md) |
| Laço observar → agir → verificar | [`procedimentos/computer-use/loop-observacao-acao.md`](./procedimentos/computer-use/loop-observacao-acao.md) |
| Diagnóstico GUI — Windows | [`procedimentos/computer-use/diagnostico-gui-windows.md`](./procedimentos/computer-use/diagnostico-gui-windows.md) |
| Diagnóstico GUI — Linux | [`procedimentos/computer-use/diagnostico-gui-linux.md`](./procedimentos/computer-use/diagnostico-gui-linux.md) |
| Registro de integração | [`vendor/agent-desktop/README.md`](./vendor/agent-desktop/README.md) |
| Créditos e licença | [`CREDITS.md`](./CREDITS.md) |

> **Limite importante:** no Windows a camada exige **sessão interativa** do usuário logado. SSH, serviço e Session 0 não conseguem dirigir a GUI do cliente. No Linux, o homologado é Ubuntu 24.04+ com AT-SPI; Debian **não** está homologado para esta camada.

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

O BCG integra o projeto [`agent-desktop`](https://github.com/vercel-labs/agent-desktop), © **Vercel Labs**, sob licença **Apache-2.0**. Créditos, escopo da integração e o que **não** é redistribuído estão em [`CREDITS.md`](./CREDITS.md) e [`docs/licenses.md`](./docs/licenses.md).

---

<sub>Idealizado e mantido por **Gabriel Subtil** — [github.com/gabrielsubtil](https://github.com/gabrielsubtil).</sub>
