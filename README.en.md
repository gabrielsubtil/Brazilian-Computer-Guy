# Brazilian Computer Guy (BCG) 🛠️🇧🇷

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Debian-lightgrey.svg)](docs/matrix-compatibility.md)
[![Agents](https://img.shields.io/badge/AI%20Agents-VS%20Code%20%7C%20Copilot%20%7C%20Antigravity%20%7C%20Claude%20%7C%20OpenCode-blueviolet.svg)](docs/architecture.md)

**Languages / Idiomas:**  
[🇧🇷 Português](README.md) | 🇺🇸 **English**

---

> **The ultimate IT Swiss Army knife for computer support technicians powered by AI agents.**  
> Advanced diagnostics, strictly safe operational procedures, absolute privacy respect, and mandatory structured service reports.

---

## 💡 About the Project

The **Brazilian Computer Guy (BCG)** is designed to empower support technicians and system administrators to perform guided, high-precision maintenance directly within their AI-assisted coding environments — with primary, native support for **VS Code**, alongside full compatibility for **Antigravity IDE**, **Claude Code**, **OpenCode**, and **OpenAI Codex**.

The agent embodies the mindset of a veteran Brazilian IT technician: resourceful and creative when investigating root causes, clear and educational in communication, and extraordinarily cautious — **never applying any system, registry, or file changes without explicit, itemized human operator authorization**.

---

## 🚀 Key Capabilities

- 🔍 **Read-Only First Diagnostics:** Comprehensive evidence collection without risks of downtime or accidental data loss.
- 🖱️ **GUI Operation (Computer Use):** Reads the OS accessibility tree (UI Automation on Windows, AT-SPI on Linux) to diagnose and operate applications that have no command-line interface — acting on element refs, with no pixel automation and no desktop focus stealing. Built on [`agent-desktop`](https://github.com/vercel-labs/agent-desktop) by Vercel Labs, with BCG governance applied command by command. See [`docs/computer-use.md`](./docs/computer-use.md).
- 🛡️ **Strict Explicit Opt-In:** Displays exact commands, targets, technical rationales, potential impacts, and verified rollback commands before modifying anything.
- 📋 **Mandatory Service Reports:** Every troubleshooting session or diagnostic intervention produces an auditable, professional **Technical Service Report** ready for client delivery or ticketing systems.
- 🧠 **Per-Machine Memory & Isolation:** Stores machine-specific profiles inside `.local/<machine-name>/` in a sanitized manner, strictly excluded from Git tracking.
- 🌐 **Comprehensive SOP Catalog:** Battle-tested, parameterized Standard Operating Procedures for Windows (8/10/11), Debian Linux, and supplemental network diagnostics.
- 🔌 **Standard MCP Integration:** Native support for **Microsoft Learn MCP** (SSE), network diagnostic servers (**mcp-nettools**), and native fallback diagnostic scripts.

---

## 📁 Repository Structure

```text
Brazilian-Computer-Guy/
├── agent.md                      # Central governing rules, pipelines, and safety protocols
├── soul.md                       # Persona and voice of the prudent Brazilian IT technician
├── README.md                     # Portuguese documentation
├── README.en.md                  # English documentation
├── CREDITS.md                    # Authorship, credits and third-party attributions
├── LICENSE                       # MIT License
├── package.json                  # Manifest, metadata, and verification scripts
├── .gitignore                    # Strict blocking of local states (.local/), logs, and reports
│
├── .github/                      # Copilot adapter, issue templates and CI
│   ├── copilot-instructions.md
│   ├── release.yml               # Release notes grouping
│   ├── ISSUE_TEMPLATE/           # Bug report and SOP proposal
│   └── workflows/validate.yml    # Validates structure, scripts and internal links
│
├── assets/                       # Social preview image
│   ├── social-preview.svg
│   └── social-preview.png
├── .vscode/                      # VS Code workspace & MCP definitions
│   ├── mcp.json                  # Microsoft Learn (SSE) + mcp-nettools (stdio)
│   └── settings.json
├── .agents/                      # Antigravity IDE adapter
│   ├── rules/brazilian-computer-guy.md # Always-On rule
│   └── mcp_config.json
├── CLAUDE.md                     # Claude Code root adapter
├── .mcp.json                     # Claude Code MCP configuration
├── .claude/settings.json         # Claude Code safety permissions
├── AGENTS.md                     # OpenCode & Codex root adapter
├── opencode.json                 # OpenCode declarative configuration
├── .codex/config.toml            # OpenAI Codex configuration
│
├── templates/                    # Clean templates (no developer machine data)
│   ├── report-template.md        # Official Technical Service Report template
│   ├── memory-template.md        # Machine hardware/OS profile template
│   ├── changelog-template.md     # Audit changelog & rollback template
│   └── session-summary-template.md # Shift handover / session summary
├── .local/.gitkeep               # Clean local persistence directory
│
├── procedimentos/                # Standard Operating Procedures (SOPs)
│   ├── windows/                  # Services, Event Logs, Power, Boot, Disk Cleanup, etc.
│   ├── debian/                   # Systemd, Journald, Boot/GRUB, APT, Packages
│   ├── rede/                     # Network connectivity, DNS, Ports, Routes
│   └── computer-use/             # GUI install, observe-act loop, accessibility diagnostics
│
├── tools/                        # Native Diagnostic & Automation Scripts
│   ├── windows/                  # Get-SystemDiagnostic.ps1, Test-NetworkHealth.ps1
│   ├── debian/                   # system_diagnostic.sh, network_health.sh
│   ├── computer-use/             # check_agent_desktop.sh, Check-AgentDesktop.ps1
│   └── reporting/generate-report.js # CLI service report compiler
│
├── docs/                         # Engineering and Governance Documentation
│   ├── architecture.md           # Modular architecture and workflow
│   ├── computer-use.md           # GUI operation layer: command classes and limits
│   ├── security-and-permissions.md # Strict safety and opt-in policies
│   ├── matrix-compatibility.md   # OS x AI Agents x Tools compatibility matrix
│   ├── licenses.md               # Third-party attributions and licenses
│   └── releases.md               # Version changelog (v1.0.0)
│
└── vendor/                       # Catalog of validated MCP servers and integrations
    ├── README.md
    └── agent-desktop/            # Integration record (Vercel Labs, Apache-2.0)
```

---

## 🖱️ Computer Use (GUI Operation)

Some problems only exist on screen: an installer that fails inside a dialog, a legacy app with no CLI, a control panel with no command-line equivalent. For those, BCG ships a GUI operation layer built on [`agent-desktop`](https://github.com/vercel-labs/agent-desktop) (**Vercel Labs**, **Apache-2.0**), which reads the OS accessibility tree instead of guessing by pixel.

```bash
npm install -g agent-desktop                            # Node.js 18+
bash tools/computer-use/check_agent_desktop.sh          # Linux/macOS, read-only check
agent-desktop status && agent-desktop permissions       # mandatory pre-flight
```

Governance does not change: observation commands (`snapshot`, `find`, `get`, `is`, `list-*`) run freely; any state-changing command (`click`, `type`, `set-value`, `launch`, `close-app`…) requires the same Intervention Proposal defined in `agent.md`. UAC, login screens, 2FA, passwords and financial data are forbidden under any circumstance.

> **Hard limit:** on Windows this layer requires an **interactive** logged-in session. SSH, services and Session 0 cannot drive the client's GUI. On Linux, Ubuntu 24.04+ with AT-SPI is the supported target; Debian is **not** validated for this layer.

---

## 💻 Quickstart in VS Code

1. Clone the repository locally:

   ```bash
   git clone https://github.com/gabrielsubtil/Brazilian-Computer-Guy.git
   cd Brazilian-Computer-Guy
   ```

2. Open the directory in **VS Code**:

   ```bash
   code .
   ```

3. Start a chat with your AI agent (e.g., **GitHub Copilot Chat** in Agent mode, Claude Code, or Antigravity).
4. The agent will automatically load [`agent.md`](./agent.md) and [`soul.md`](./soul.md).
5. Specify the target machine hostname (e.g., `DESKTOP-CLIENT01`) and describe the reported issue.
6. Follow the read-only diagnosis, authorize individual recommended steps, and generate the service report upon completion!

---

## 📊 Technical Service Report Generation

Every diagnostic or maintenance operation can compile an auditable, professional report at any time:

```bash
npm run report -- --machine="MACHINE_NAME"
```

Or by directly prompting your agent: *"Generate the final service report for this machine"*.

The output document follows strict IT engineering standards, ready to be attached to corporate tickets or delivered to clients.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](./LICENSE) for full details.

BCG integrates [`agent-desktop`](https://github.com/vercel-labs/agent-desktop), © **Vercel Labs**, under the **Apache-2.0** license. Credits, integration scope and what is **not** redistributed are documented in [`CREDITS.md`](./CREDITS.md) and [`docs/licenses.md`](./docs/licenses.md).
