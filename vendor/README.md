# Catálogo de Servidores MCP e Ferramentas Homologadas (`vendor/`)

Este diretório documenta as ferramentas, bibliotecas e servidores **MCP (Model Context Protocol)** homologados para o ecossistema **Brazilian Computer Guy (BCG)**, suas finalidades operacionais, requisitos de runtime e procedimentos de ativação.

---

## 1. Servidores de Documentação Oficial (Prioridade Zero)

### Microsoft Learn MCP
- **Origem:** Oficial Microsoft (`https://learn.microsoft.com/api/mcp`)
- **Transporte:** Streamable HTTP / Server-Sent Events (SSE)
- **Autenticação:** Não requer chaves ou credenciais
- **Finalidade:** Consulta aprofundada da documentação técnica oficial de cmdlets PowerShell, APIs do Windows, códigos de erro Win32, arquitetura de serviços e diretrizes de suporte.
- **Configuração no VS Code (`.vscode/mcp.json`):**
  ```json
  "microsoft-learn": {
    "type": "sse",
    "url": "https://learn.microsoft.com/api/mcp"
  }
  ```

### Man MCP Server (Debian / Linux)
- **Origem:** `guyru/man-mcp-server`
- **Transporte:** Stdio (Python 3.10+)
- **Finalidade:** Consulta aos manuais locais (`man`, `apropos`) instalados exatamente na versão do Debian em atendimento, assegurando precisão de sintaxe e parâmetros.

---

## 2. Diagnóstico e Rede Complementar

### mcp-nettools
- **Origem:** GitHub: `aaronckj/mcp-nettools` · PyPI: `mcp-nettools`
- **Transporte:** Stdio (Python 3.12+)
- **Capacidades Oferecidas:**
  - `ping_host`: Verificação de latência e perda de pacotes
  - `dns_lookup`: Resolução direta e reversa com múltiplos tipos de registros (A, AAAA, MX, TXT)
  - `port_check`: Verificação de portas TCP abertas em alvos autorizados
  - `traceroute`: Mapeamento de saltos de rede
  - `ssl_cert_check`: Inspeção de validade, emissores e expiração de certificados TLS/SSL
- **Instalação Local:**
  ```bash
  pip install mcp-nettools
  ```

---

## 3. Servidores de Administração e Operação Windows

### windows-admin-mcp
- **Origem:** `devladpopov/windows-admin-mcp`
- **Requisitos:** Node.js 18+, PowerShell 5.1+ (Windows 10/11)
- **Finalidade:** Consulta e auditoria de serviços do Windows e Event Logs via interface estruturada MCP.

### Utilitários Nativos Incorporados (Fallback Confiável)
Para garantir máxima resiliência mesmo quando servidores MCP externos não puderem ser inicializados (ex: restrições de firewall corporativo ou falta de Node/Python), o BCG inclui scripts nativos em:
- `tools/windows/Get-SystemDiagnostic.ps1`
- `tools/windows/Test-NetworkHealth.ps1`
- `tools/debian/system_diagnostic.sh`
- `tools/debian/network_health.sh`

Esses utilitários funcionam nativamente sem dependências externas, garantindo que o técnico nunca fique sem capacidade diagnóstica.

---

## 4. Operação de Interface Gráfica

### agent-desktop (Vercel Labs)
- **Origem:** [vercel-labs/agent-desktop](https://github.com/vercel-labs/agent-desktop) — mantido pelo Vercel Labs, licença **Apache-2.0** ([LICENSE](https://github.com/vercel-labs/agent-desktop/blob/main/LICENSE)).
- **Referência:** npm `agent-desktop` v1.2.0, revisão `b43ac4f6e892ef608f8851428613c4009f0e84c7` (2026-11-05). [Documentação upstream](https://agent-browser.dev/desktop).
- **Transporte:** CLI (`agent-desktop`) e servidor MCP stdio (`agent-desktop mcp`), executados localmente.
- **Requisitos:** Node.js 18+ e binário nativo; Windows 10 1809+ / Server 2019+ (x64/ARM64) em sessão interativa, ou Ubuntu 24.04+ (x86_64/aarch64), glibc ≥ 2.35 e AT-SPI em sessão gráfica. Debian 11/12 não homologado; macOS 13+ suportado no upstream, fora do escopo do BCG. Limites de Session 0/SSH e Wayland em [`matrix-compatibility.md`](../docs/matrix-compatibility.md).
- **Capacidades Oferecidas:**
  - Observação por árvore de acessibilidade e snapshots com referências qualificadas.
  - Ações por referência de elemento, subordinadas à aprovação explícita da Classe B.
  - Sessões e trace para acompanhamento da operação, com proteção do conteúdo privado.
  - Envelope JSON com `disposition.delivery` e `disposition.retry`; repetição somente quando `retry == safe`.
- **Governança:** Headless por padrão; `--headed` exige autorização separada para entrada física. Classe C nunca é autorizada.
- **Configuração MCP nos clientes:** Declarar o servidor local `agent-desktop`, com comando `agent-desktop` e argumento `mcp`, respeitando o formato de cada cliente:

  | Cliente | Arquivo de configuração |
  |---|---|
  | VS Code / Copilot | `.vscode/mcp.json` |
  | Antigravity IDE | `.agents/mcp_config.json` |
  | Claude Code | `.mcp.json` |
  | OpenCode | `opencode.json` |
  | Codex | `.codex/config.toml` |

- **Registro e regras:** [`vendor/agent-desktop/README.md`](./agent-desktop/README.md) e [`docs/computer-use.md`](../docs/computer-use.md).
- **Atribuição:** `agent-desktop` é um projeto do Vercel Labs, sob Apache-2.0. O BCG não redistribui seu código ou binário, e esta integração não é endossada pela Vercel. Créditos completos em [`CREDITS.md`](../CREDITS.md).
