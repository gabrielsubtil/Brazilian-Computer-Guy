# `agent-desktop` — Registro de Integração (`vendor/agent-desktop/`)

Este diretório **não contém** código, binário ou cópia de arquivos do projeto upstream. Contém apenas o **registro auditável** da integração: o que foi adotado, em qual revisão, sob qual licença e com qual escopo.

---

## 1. Identificação

| Campo | Valor |
|---|---|
| Projeto | `agent-desktop` — *Computer use for AI agents: see and operate desktop apps on macOS, Windows, and Linux through the OS accessibility tree.* |
| Repositório | <https://github.com/vercel-labs/agent-desktop> |
| Mantenedor | Vercel Labs |
| Licença | Apache-2.0 (`LICENSE` do repositório upstream) |
| Pacote | npm `agent-desktop` v1.2.0 · binário `agent-desktop` · requer Node.js ≥ 18 |
| Revisão fixada | `b43ac4f6e892ef608f8851428613c4009f0e84c7` (2026-11-05) |
| Documentação | <https://agent-browser.dev/desktop> |
| Superfície usada pelo BCG | CLI + servidor MCP (`agent-desktop mcp`) |

---

## 2. Por que foi adotado

O BCG precisava de **operação de interface gráfica** com três propriedades que a automação por pixel não entrega:

1. **Semântica em vez de coordenada.** O agente lê a árvore de acessibilidade e age por referência de elemento, o que é resistente a mudança de resolução, tema e escala.
2. **Sem roubar o foco do usuário.** Ações por referência são *headless* por padrão — requisito de respeito ao ambiente do cliente.
3. **Contrato de erro honesto.** O envelope JSON informa `disposition.delivery` e `disposition.retry`; o agente sabe quando **pode** repetir e quando repetir causaria efeito duplicado.

Nenhuma alternativa avaliada entregava os três ao mesmo tempo, em Windows e Linux, com MCP pronto.

---

## 3. Escopo da integração

### Adotado

- Declaração do servidor MCP `agent-desktop` nos cinco arquivos de configuração de clientes do BCG.
- Vocabulário de comandos (observação, ação, sessão) convertido em **Classes A, B e C** no [`docs/computer-use.md`](../../docs/computer-use.md).
- Regras de laço, referências e repetição segura convertidas em SOP próprio, em português do Brasil.
- Orientações de plataforma (Windows UIA, Linux AT-SPI) convertidas em procedimentos de diagnóstico GUI.
- Verificação de instalação e teste de fumaça somente leitura em `tools/computer-use/`.

### Não adotado

- Código-fonte, binários, releases e arquivos de `skills/` do upstream **não são redistribuídos** neste repositório.
- Suporte a macOS: existe no upstream, **fora do escopo homologado** do BCG.
- `--headed` como padrão: o BCG mantém headless por padrão e `--headed` só com autorização explícita.
- Qualquer flag de bypass (`--force`, autoaprovação, laço automático): **proibido** no BCG.

---

## 4. Instalação (feita pelo usuário, da fonte oficial)

```bash
# Windows, Linux e macOS — via npm
npm install -g agent-desktop
agent-desktop version
agent-desktop status

# macOS e Linux — alternativa oficial
brew install agent-desktop
```

Verificação completa em [`procedimentos/computer-use/instalacao-e-verificacao.md`](../../procedimentos/computer-use/instalacao-e-verificacao.md).

---

## 5. Atribuição

Atribuição completa, incluindo o que é derivado e o que não é, em [`CREDITS.md`](../../CREDITS.md) (seção 2) e [`docs/licenses.md`](../../docs/licenses.md) (seção 6).

> `agent-desktop` é © Vercel Labs, licenciado sob Apache-2.0. O Brazilian Computer Guy integra seu contrato de CLI/MCP e adapta suas regras públicas de operação para a governança do BCG. Esta integração não é endossada pela Vercel.

---

## 6. Validação executada

Registro do teste real feito ao integrar a camada. Serve para separar **o que foi verificado** do que continua **não validado**.

| Item | Valor |
|---|---|
| Data | 2026-11-05 |
| Ambiente | Debian GNU/Linux 13 (trixie), x86_64, sem sessão gráfica e sem barramento D-Bus |
| Node.js / npm | v26.12.1 / 12.0.2 |
| Instalação | `npm install agent-desktop` (local, postinstall bloqueado pelo gerenciador; execução pelo launcher Node) |
| Versão instalada | **1.2.0**, envelope `"version":"2.6"` |

Resultados observados:

| Comando | Resultado |
|---|---|
| `version` | `{"version":"2.6","ok":true,"command":"version","data":{"os":"linux","target":"x86_64","version":"1.2.0"}}` |
| `status` | `ok:true`; `platform: linux`; `permissions.accessibility.state: denied` com sugestão "No D-Bus session bus is reachable"; `automation: not_required`; `screen_recording: unknown`; `supported_surfaces: []` |
| `permissions` | mesmo bloco de permissões do `status` |
| `list-apps` | `ok:false`; `error.code: PLATFORM_NOT_SUPPORTED`; `disposition: {delivery: not_delivered, retry: safe}` |

O que isso **prova**:

- o binário oficial instala e executa em x86_64 com Node 18+;
- o formato do envelope e a semântica de `disposition.retry` descritos em `docs/computer-use.md` correspondem ao comportamento real;
- `supported_surfaces` vazio decorre de ausência de sessão gráfica/D-Bus, exatamente como o procedimento afirma — não de "desktop vazio";
- `tools/computer-use/check_agent_desktop.sh` funciona nos três cenários testados: ausência do binário (saída `2`), binário sem sessão gráfica (avisos coerentes, saída `1`) e launcher npm com aviso antes do JSON (envelope extraído corretamente).

O que isso **não prova**:

- **nenhuma** operação de interface (snapshot, clique, digitação) foi executada — o ambiente não tinha sessão gráfica;
- **homologação de Debian** para a camada: continua não homologado;
- execução do `Check-AgentDesktop.ps1`: o ambiente não possui PowerShell; o script foi revisado manualmente, **não executado**;
- qualquer comportamento em Windows.

## 7. Atualização da integração

Ao atualizar a versão fixada:

1. Registrar a nova revisão e a data neste arquivo.
2. Reexecutar `tools/computer-use/check_agent_desktop.sh` (ou `Check-AgentDesktop.ps1`) e anexar a saída ao changelog.
3. Revisar `docs/computer-use.md` se o envelope JSON, as classes de comando ou os requisitos de plataforma mudarem.
4. **Não** atualizar `docs/matrix-compatibility.md` para "homologado" sem teste local correspondente.
