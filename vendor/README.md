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
