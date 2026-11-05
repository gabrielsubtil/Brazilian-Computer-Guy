# Histórico de Versões do Brazilian Computer Guy (`docs/releases.md`)

Todas as alterações notáveis do produto serão documentadas neste arquivo, seguindo o padrão de versionamento semântico.

---

## [1.0.0] - 2026-09-17

### Lançamento Inicial (MVP)
- **Núcleo de Governança:** Criação de `agent.md` e `soul.md` estabelecendo o protocolo inegociável de opt-in prévio e postura técnica cuidadosa.
- **Adaptadores de IA:** Suporte nativo para VS Code (Copilot), Antigravity IDE, Claude Code, OpenCode e OpenAI Codex.
- **Sistema de Relatórios Obrigatórios:** Implementação de `templates/report-template.md` e ferramenta CLI `tools/reporting/generate-report.js` para compilação automática de ordens de serviço e relatórios técnicos.
- **Isolamento e Persistência:** Estrutura `.local/<nome-da-maquina>/` sanitizada, baseada em templates limpos e com exclusão do Git.
- **Procedimentos Operacionais Padronizados (SOPs):**
  - **Windows:** Serviços, Event Viewer, Energia, Boot, Limpeza de Cache, Programas, Integridade de Hardware e Perfil Legado Windows 8.
  - **Debian:** Serviços Systemd, Logs Journald, Boot/GRUB, Limpeza APT e DPKG.
  - **Rede Complementar:** Conectividade em degraus, Resolução DNS, Portas/Conexões e Roteamento.
- **Ferramentas e MCPs:** Scripts de diagnóstico somente leitura para PowerShell e Bash; catálogo de MCPs homologados com Microsoft Learn e mcp-nettools.

---

## [1.1.0] - 2026-10-07

### Camada de Pipelines

- **Nova pasta `pipelines/`:** separação explícita entre Procedimentos Operacionais Padronizados (SOP, tarefa por área) e pipelines (fluxo de decisão longo, com triagem, regras inegociáveis, proposta obrigatória e rollback). Formato e checklist documentados em `pipelines/README.md`.
- **`PIPE-WIN-01` — `pipelines/reducao-de-processos-windows.md`:** redução segura de processos, com priorização de aplicativos de terceiros, bloqueio de desativação de proteções e serviços, e seção 8 que admite, sob condições estritas, o ajuste de Registro do limiar de agrupamento de serviços (`SvcHostSplitThresholdInKB`), com tabela RAM → valor em hexadecimal.
- **`PIPE-WIN-02` — `pipelines/otimizacao-registro-windows.md`:** catálogo de ajustes de Registro em quatro classes — A (permitido e documentado), B (efeito limitado ou condicionado por edição), C (bloqueado ou revertido pela Microsoft) e D (ineficaz ou contraproducente) — com fonte oficial por item, selo de recomendação, proposta obrigatória e **exigência de informar ao usuário se o ajuste é recomendado, apenas permitido ou ineficaz**, deixando a decisão de aplicar com o usuário.
- **Registro e gatilhos:** as duas pipelines constam da matriz de procedimentos do `agent.md` (seção 4) e dos gatilhos da Fase 1, replicados no `geminai.md`.
- **Atualização da árvore de estrutura do `README.md`** para incluir a pasta `pipelines/`.

---

## [1.2.0] - 2026-11-05

### Camada de Operação por Interface Gráfica (Computer Use)

- **Nova camada arquitetural:** o BCG passa a operar aplicativos de interface gráfica através do projeto open source [`agent-desktop`](https://github.com/vercel-labs/agent-desktop), do **Vercel Labs** (licença **Apache-2.0**, versão fixada **1.2.0**, revisão `b43ac4f`). A integração usa o contrato de CLI e MCP; **nada do projeto upstream é redistribuído** neste repositório.
- **`docs/computer-use.md`:** documento de arquitetura da camada, com a divisão dos cerca de 56 comandos em três classes — **A (observação, sem autorização)**, **B (ação de interface, exige Proposta de Intervenção)** e **C (proibida sempre: UAC, tela de login, 2FA, senha, dado financeiro)** — além de regras de referência por snapshot, repetição segura por `disposition.retry`, headless como padrão e privacidade de snapshot/screenshot.
- **`agent.md` seção 6:** governança da camada dentro do ciclo de atendimento, com pré-voo obrigatório (`status`, `permissions`), regra de precedência do shell sobre a GUI e limites que impedem promessa indevida.
- **SOPs novos em `procedimentos/computer-use/`:** instalação e verificação, laço observar → agir → verificar, diagnóstico GUI no Windows (UI Automation) e diagnóstico GUI no Linux (AT-SPI).
- **Ferramentas de verificação em `tools/computer-use/`:** `check_agent_desktop.sh` (Linux/macOS) e `Check-AgentDesktop.ps1` (Windows), ambas **somente leitura**, com `npm run computer-use:check`.
- **MCP em todos os clientes:** servidor `agent-desktop` declarado em `.mcp.json`, `.vscode/mcp.json`, `.agents/mcp_config.json`, `opencode.json` e `.codex/config.toml`.
- **Atribuição:** novos `CREDITS.md` e `vendor/agent-desktop/README.md` registram autoria, escopo da integração, licença Apache-2.0 e o que foi adotado e o que não foi. `docs/licenses.md`, `docs/matrix-compatibility.md`, `docs/security-and-permissions.md` e `docs/architecture.md` atualizados.
- **Limites declarados:** no Windows a camada exige sessão interativa (SSH, serviço e Session 0 não dirigem a GUI); no Linux, Ubuntu 24.04+ com AT-SPI é o alvo homologado e **Debian não está homologado** para esta camada; em Wayland os gestos de ponteiro recusam.
