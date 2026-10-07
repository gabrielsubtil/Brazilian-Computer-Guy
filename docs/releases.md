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
