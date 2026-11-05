# Matriz Oficial de Compatibilidade — BCG

Esta matriz define a compatibilidade homologada do **Brazilian Computer Guy** entre Sistemas Operacionais, Ambientes de IA e Servidores de Ferramentas/MCP.

---

## 1. Sistemas Operacionais

| Sistema Operacional | Nível de Suporte | Runtimes Recomendados | Observações e Limitações |
|---|---|---|---|
| **Windows 7 SP1** | **Legado / Não suportado** | PowerShell 2.0+ / WMI | Suporte encerrado; o BCG só oferece diagnóstico compatível e orienta migração ou isolamento. Não prometer ferramentas modernas. |
| **Windows 11 (22H2 / 23H2 / 24H2)** | **Nativo / Pleno** | PowerShell 5.1 / 7+, Winget | Suporte completo a todos os SOPs, DISM, SFC e MCPs. |
| **Windows 10 (21H2 / 22H2)** | **Legado / Condicionado** | PowerShell 5.1 / 7+, Winget | Home/Pro 22H2 encerrou suporte geral em 14/10/2025; validar edição, ESU/LTSC e plano de migração antes de qualquer manutenção. |
| **Windows 8 / 8.1** | **Legado / Condicionado** | PowerShell 4.0 / WMI | Winget indisponível. Cmdlets modernos de rede ausentes. Seguir `SOP-WIN-LEGACY`. |
| **Debian 12 (Bookworm)** | **Nativo / Pleno** | Bash 5+, Python 3.11+, Systemd | Suporte total a SOPs de Systemd, APT, Journald e rede. |
| **Debian 11 (Bullseye)** | **Nativo / Pleno** | Bash 5+, Python 3.9+, Systemd | Suporte total aos SOPs Debian. |

### 1.1 Camada de Computer Use (agent-desktop)

A compatibilidade da GUI é independente dos SOPs e runtimes acima. Os requisitos abaixo seguem o upstream; não representam teste local de todas as combinações.

| Sistema Operacional | Suporte da camada | Requisitos e limites |
|---|---|---|
| **Windows 10 / 11** | **Suportado em sessão interativa** | Windows 10 1809+; x64/ARM64; sessão gráfica do usuário logado. |
| **Windows 8 / 8.1** | **Não suportado** | Fora dos requisitos do upstream. |
| **Windows 7** | **Não suportado** | Fora dos requisitos do upstream. |
| **Debian 11 / 12** | **Não homologado** | Fora do alvo oficial; exige glibc ≥ 2.35 e verificação do fix `dc0dc33` do bridge AT-SPI. Não inferir suporte a partir dos SOPs Debian. |
| **Ubuntu 24.04+** | **Suportado (referência do upstream)** | x86_64/aarch64, glibc ≥ 2.35 e AT-SPI em sessão gráfica; GNOME medido, com diferenças entre X11 e Wayland. |
| **macOS 13+** | **Suportado no upstream; fora do escopo do BCG** | Não integra o escopo homologado do BCG. |

**Session 0 / SSH:** no Windows, serviço, tarefa SYSTEM ou SSH sem desktop interativo não permitem operar a GUI. UAC, secure desktop e tela de login não são suportados e são proibidos no BCG.

**Wayland:** `drag`, `hover`, `double-click`, `triple-click`, `mouse-click` e wheel físico são recusados; `focus-window` exige X11. Screenshot depende do portal de consentimento, e clipboard exige `wl-clipboard`. Esses requisitos não autorizam o agente a operar diálogos de consentimento de segurança.

Escopo e comportas de autorização: [`computer-use.md`](./computer-use.md).

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
| **agent-desktop** | Stdio (`agent-desktop mcp`) / CLI local | Node.js 18+, binário nativo e sessão gráfica; AT-SPI/glibc ≥ 2.35 no Linux | Windows 10 1809+/11 e Server 2019+ (x64/ARM64); Ubuntu 24.04+ (x86_64/aarch64); macOS 13+ apenas no upstream; Debian 11/12 não homologado |
| **Scripts Nativos BCG (`tools/`)** | Local CLI | PowerShell nativo / Bash | Todas as plataformas suportadas |
