# Créditos, Autoria e Atribuições — Brazilian Computer Guy

O **Brazilian Computer Guy (BCG)** é um projeto de **Gabriel Subtil** (Tambotech / IQTrank), distribuído sob licença **MIT**.

Este arquivo registra, de forma explícita, **quem construiu o quê**. Ele existe porque o BCG integra e adapta trabalho de terceiros, e crédito correto não é etiqueta decorativa: é requisito de licença e é o que permite ao usuário final saber qual parte do sistema ele pode auditar, substituir ou portar.

---

## 1. Autoria do BCG

| Papel | Responsável |
|---|---|
| Idealização, arquitetura de governança, SOPs, pipelines e persona | **Gabriel Subtil** — [github.com/gabrielsubtil](https://github.com/gabrielsubtil) |
| Implementação assistida por agente de IA (Hermes) | Gabriel Subtil + agentes, sob revisão humana |

O BCG é um **projeto de engenharia de prompt e governança operacional**: o que ele entrega é protocolo, procedimento, comporta de autorização, template de relatório e utilitário de diagnóstico — não um runtime proprietário.

---

## 2. Camada de Computer Use — `agent-desktop` (Vercel Labs)

A camada de operação de interface gráfica do BCG ([`docs/computer-use.md`](./docs/computer-use.md)) é construída sobre o projeto **`agent-desktop`**, do **Vercel Labs**.

| Campo | Valor |
|---|---|
| Projeto | `agent-desktop` — *Computer use for AI agents* |
| Repositório | <https://github.com/vercel-labs/agent-desktop> |
| Mantenedor | **Vercel Labs** (Vercel) |
| Licença | **Apache-2.0** — <https://github.com/vercel-labs/agent-desktop/blob/main/LICENSE> |
| Pacote | `agent-desktop` no npm (binário `agent-desktop`) |
| Versão de referência | **1.2.0** |
| Revisão fixada | `b43ac4f6e892ef608f8851428613c4009f0e84c7` (2026-11-05) |
| Documentação | <https://agent-browser.dev/desktop> |

### O que o BCG usa do `agent-desktop`

1. **O contrato da CLI e do servidor MCP** (`agent-desktop mcp`) — o BCG declara o servidor nos arquivos de configuração dos clientes de IA e ensina o agente a usar os comandos.
2. **As regras do laço observar → agir → verificar**, reescritas em português do Brasil e **subordinadas à governança do BCG**: referências qualificadas por snapshot, tratamento de `STALE_REF`/`AMBIGUOUS_TARGET`, repetição apenas com `disposition.retry = safe`, headless por padrão.
3. **As orientações específicas de plataforma** (UI Automation no Windows, AT-SPI no Linux), convertidas em procedimentos operacionais do BCG com as comportas de autorização da casa.

### O que o BCG **não** faz com o `agent-desktop`

- **Não redistribui** o binário nem o código-fonte do projeto. A instalação é feita pelo usuário, via `npm install -g agent-desktop` ou `brew install agent-desktop`, direto da fonte oficial.
- **Não copia** arquivos do repositório upstream para dentro do BCG. O que existe aqui é **texto próprio**, derivado das regras públicas do projeto, com atribuição.
- **Não modifica** o projeto upstream. Se o BCG precisar de mudança no `agent-desktop`, ela deve ser proposta no repositório de origem.

Como não há redistribuição de código nem de binário, o arquivo `NOTICE` do Apache-2.0 não é replicado; a atribuição exigida é cumprida por este arquivo, por [`docs/licenses.md`](./docs/licenses.md) e por [`vendor/agent-desktop/README.md`](./vendor/agent-desktop/README.md).

### Marcas

"Vercel", "Vercel Labs" e os logotipos associados são marcas de seus titulares. O uso neste repositório é **descritivo** (identificar a origem do componente integrado). Esta integração **não é endossada, patrocinada ou certificada** pela Vercel, e o BCG não fala em nome do Vercel Labs.

---

## 3. Outros componentes e referências

| Componente | Origem | Licença | Uso no BCG |
|---|---|---|---|
| Microsoft Learn MCP | Microsoft | Termos de uso da API Microsoft Learn | Consulta de documentação oficial |
| `mcp-nettools` | aaronckj | MIT | Diagnóstico complementar de rede |
| `man-mcp-server` | guyru | MIT | Manuais locais no Linux |
| `windows-admin-mcp` | devladpopov | MIT | Auditoria de serviços/Event Viewer |
| Model Context Protocol | Anthropic + comunidade | Aberto | Padrão de interoperabilidade agente ↔ ferramenta |

Detalhamento em [`docs/licenses.md`](./docs/licenses.md).

---

## 4. Como citar o BCG

```text
Brazilian Computer Guy (BCG) — Gabriel Subtil.
https://github.com/gabrielsubtil/Brazilian-Computer-Guy
Camada de Computer Use construída sobre agent-desktop (Vercel Labs, Apache-2.0).
```
