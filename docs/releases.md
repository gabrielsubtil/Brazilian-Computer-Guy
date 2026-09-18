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
