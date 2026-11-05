# Verificação de Computer Use — BCG

Diagnóstico **SOMENTE LEITURA** da instalação local de
[`agent-desktop`](https://github.com/vercel-labs/agent-desktop), do **Vercel Labs**,
licença **Apache-2.0**. Consulte a [arquitetura e regras de segurança](../../docs/computer-use.md)
e o [procedimento de instalação e verificação](../../procedimentos/computer-use/instalacao-e-verificacao.md).

## Execução

Execute no computador do técnico, no diretório desta ferramenta, como usuário normal.
Não exige administrador nem `sudo`.

Linux/macOS:

```bash
bash check_agent_desktop.sh
printf 'Código de saída: %s\n' "$?"
```

Windows (PowerShell 5.1+):

```powershell
powershell -ExecutionPolicy Bypass -File .\Check-AgentDesktop.ps1
$LASTEXITCODE
```

`Bypass` vale apenas para o processo iniciado; o script não altera a política persistente.
Políticas organizacionais ainda podem impedir a execução. O arquivo `.ps1` usa UTF-8 com
BOM para preservar o português no Windows PowerShell 5.1.

## O que é verificado

- Presença de `agent-desktop` no PATH; se ausente, informa a instalação **manual**
  (`npm install -g agent-desktop`) e termina com código 2.
- Versões de Node.js (esperado >= 18) e npm: informativas, sem instalar dependências.
  Ausência ou versão inadequada gera AVISO, não impede as outras verificações.
- `agent-desktop version`, `status` e `permissions`; interpreta o envelope JSON
  `ok`/`data`/`error`, informa plataforma, quantidade de `supported_surfaces` e permissões.
- Teste de fumaça `agent-desktop list-apps`: **somente a contagem**, sem nomes,
  títulos ou JSON bruto da lista, nem mensagens de erro que possam contê-los.
- Sessão gráfica Linux (`DISPLAY`/`WAYLAND_DISPLAY`); Debian não homologado,
  somente Ubuntu 24.04+ como alvo oficial Linux. macOS é suportado pelo upstream,
  mas não homologado no escopo atual BCG.
- Windows: heurística de Session 0, serviço e SSH; execute no desktop interativo
  do usuário. Variáveis e identificador da sessão não garantem acesso à GUI.
- Diretório `~/.agent-desktop`: no Linux/macOS, verifica modo 700 e alerta sobre
  links simbólicos; no Windows, alerta para revisão manual de ACLs (não há modo
  POSIX 700 equivalente). Ausência do diretório não cria nada.

As chamadas externas de diagnóstico têm limite de 20 segundos. Bash usa
`timeout`/`gtimeout` ou `python3`; sem nenhum deles, não executa comandos sem limite
e registra a falha (código interno 125). PowerShell usa jobs isolados com timeout.
Não confunda códigos internos das consultas com o código final da ferramenta.

Bash usa `jq` quando disponível. Sem `jq`, usa `python3` com AVISO; sem ambos,
mostra apenas status/permissões brutos com AVISO e não tenta adivinhar a contagem.
PowerShell usa `ConvertFrom-Json`. Formatos desconhecidos e envelopes `ok:false`
são classificados como FALHA, sem interromper as demais verificações.

## Interpretação

Ambos apresentam registros `[OK]`, `[AVISO]`, `[FALHA]`, uma matriz final e
contagens por classificação:

- **OK:** consulta válida ou requisito observado. Não é homologação geral.
- **AVISO:** condição que exige revisão (sessão, permissão pendente, plataforma
  não homologada ou dependência informativa). Nunca corrige automaticamente.
- **FALHA:** consulta recusada, timeout, JSON inesperado ou binário ausente.

`false`, `denied`, `not_granted`, `unknown`, `not_determined` e `restricted` nas
permissões geram AVISO, assim como permissões vazias. Os valores são apresentados
para revisão técnica; formatos ou estados novos precisam de interpretação humana.
`supported_surfaces` não vazio sinaliza capacidade de acessibilidade, não prova
acesso a qualquer janela. Lista vazia de aplicativos é uma resposta válida (0),
não prova de sessão gráfica funcional. Revise os avisos de sessão separadamente.

| Código de saída | Significado |
|---|---|
| 0 | Todas as verificações executadas ficaram OK |
| 1 | Há pelo menos um AVISO ou FALHA |
| 2 | Binário `agent-desktop` ausente no PATH |

## O que NÃO faz

Não instala, atualiza, concede permissões, solicita elevação, altera configurações,
cria arquivos, inicia sessões do agent-desktop ou dirige GUI. Não executa snapshot,
screenshot, cliques, digitação, leitura de área de transferência nem abre aplicativos.
Não usa `permissions --guide`/`--request`, `--headed`, `--trace` ou comandos de ação.
Consulta apenas `version`, `status`, `permissions` e `list-apps`.

O script não escreve relatórios em disco. O comportamento interno da versão instalada
do CLI é responsabilidade do upstream; estas verificações não são um sandbox.
Status e permissões brutos podem conter metadados locais: revise antes de compartilhar.
