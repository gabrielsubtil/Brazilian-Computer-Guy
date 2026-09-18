# Matriz Oficial de Compatibilidade — BCG

Esta matriz define a compatibilidade homologada do **Brazilian Computer Guy** entre Sistemas Operacionais, Ambientes de IA e Servidores de Ferramentas/MCP.

---

## 1. Sistemas Operacionais

| Sistema Operacional | Nível de Suporte | Runtimes Recomendados | Observações e Limitações |
|---|---|---|---|
| **Windows 11 (22H2 / 23H2 / 24H2)** | **Nativo / Pleno** | PowerShell 5.1 / 7+, Winget | Suporte completo a todos os SOPs, DISM, SFC e MCPs. |
| **Windows 10 (21H2 / 22H2)** | **Nativo / Pleno** | PowerShell 5.1 / 7+, Winget | Suporte completo. Requer Winget atualizado via App Installer. |
| **Windows 8 / 8.1** | **Legado / Condicionado** | PowerShell 4.0 / WMI | Winget indisponível. Cmdlets modernos de rede ausentes. Seguir `SOP-WIN-LEGACY`. |
| **Debian 12 (Bookworm)** | **Nativo / Pleno** | Bash 5+, Python 3.11+, Systemd | Suporte total a SOPs de Systemd, APT, Journald e rede. |
| **Debian 11 (Bullseye)** | **Nativo / Pleno** | Bash 5+, Python 3.9+, Systemd | Suporte total aos SOPs Debian. |

---

## 2. Clientes e Ambientes de IA

| Cliente de IA | Adaptador de Instruções | Configuração de MCP | Nível de Suporte |
|---|---|---|---|
| **VS Code + GitHub Copilot** | `.github/copilot-instructions.md` | `.vscode/mcp.json` | **Principal (Foco do MVP)** |
| **Antigravity IDE** | `.agents/rules/brazilian-computer-guy.md` | `.agents/mcp_config.json` | **Nativo** |
| **Claude Code (Anthropic)** | `CLAUDE.md` (`@agent.md`) | `.mcp.json` | **Nativo** |
| **OpenCode** | `AGENTS.md` | `opencode.json` | **Nativo** |
| **OpenAI Codex Local** | `AGENTS.md` | `.codex/config.toml` | **Nativo** |

---

## 3. Servidores MCP e Ferramentas

| Ferramenta / Servidor | Protocolo | Dependências | Plataformas Suportadas |
|---|---|---|---|
| **Microsoft Learn MCP** | SSE (HTTP Streamable) | Acesso à Internet | Windows 10, Windows 11, Windows 8 |
| **mcp-nettools** | Stdio | Python 3.12+ | Windows 10/11, Debian 11/12 |
| **man-mcp-server** | Stdio | Python 3.10+, `man` | Debian 11, Debian 12 |
| **windows-admin-mcp** | Stdio | Node.js 18+, PowerShell 5.1+ | Windows 10, Windows 11 |
| **Scripts Nativos BCG (`tools/`)** | Local CLI | PowerShell nativo / Bash | Todas as plataformas suportadas |
