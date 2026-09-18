# Brazilian Computer Guy — PRD

**Versão:** 1.0 · **Data:** 17 de setembro de 2026 · **Idioma:** português do Brasil.

Especificação para implementação futura por um agente de IA. Este documento não instala ferramentas nem executa manutenção. O repositório do produto ainda será criado; `URL_DO_REPOSITORIO_BCG` representa seu endereço futuro.

## 1. Visão e público

O **Brazilian Computer Guy** será um “canivete suíço de TI” para técnicos de informática: um repositório GitHub com instruções para agentes, procedimentos, comandos preestabelecidos e ferramentas incorporadas. O técnico fornecerá o endereço do projeto ao seu ambiente de IA e receberá uma preparação guiada, seguida de atendimento em linguagem natural.

O foco principal é **diagnóstico e manutenção do sistema operacional**. Rede é complementar. A execução prioritária ocorre diretamente no computador atendido; atendimento remoto também deverá ser possível, como evolução opcional.

### Personalidade e comportamento obrigatórios

O agente deve agir como um técnico brasileiro criativo, versátil e cuidadoso: investigar alternativas, justificar a escolha e preferir a intervenção mínima e reversível.

- Começar pelo diagnóstico somente leitura. **Sempre pedir autorização explícita e específica antes de alterar o sistema ou arquivos**, apresentando ação, alvos, motivo, efeitos e possibilidade de reversão.
- A regra abrange preparação do ambiente, instalações/desinstalações, configurações, serviços, energia, boot, limpeza/exclusão, sobrescrita, movimentação e cópia/transferência de arquivos sensíveis. Nunca excluir por iniciativa própria.
- Não ler, expor, copiar ou enviar arquivos sensíveis desnecessariamente; quando indispensável, explicar a necessidade e obter autorização. Não inserir segredos em consultas documentais, relatórios ou contexto do modelo.
- Sem autorização, apresentar a proposta e aguardar. Autorizar diagnóstico não autoriza correção; mudança de escopo exige nova autorização. Um pedido genérico de manutenção não libera alterações indiscriminadas.
- Aplicar essas regras às instruções, scripts, clientes e MCPs. Não desativar proteções para facilitar a execução; confirmação interna de um MCP não substitui consentimento do técnico.

## 2. Escopo e prioridades

**Definido pelo usuário:** Windows 8, 10 e 11; Linux com prioridade para Debian; OpenCode, VS Code com agente/modelo, Codex, Claude da Anthropic e Antigravity IDE. Cada combinação dependerá de validação de sistema, versão, arquitetura, cliente e runtime. Não prometer que clientes modernos funcionarão no Windows 8.

**Proposta de MVP:** validar primeiro Windows 10/11 e uma versão de Debian explicitamente registrada; oferecer Windows 8 como perfil legado condicionado a testes, com procedimentos compatíveis e limitações declaradas. Não tratar WSL como equivalente a executar manutenção nativa do Windows.

| Área | Comportamento requerido |
|---|---|
| Serviços | Inventariar estado, dependências e finalidade; justificar candidatos a automático/manual; alterar somente após aprovação. |
| Logs e erros | Correlacionar eventos, contexto e documentação; separar evidências de hipóteses; preservar logs. |
| Energia | Verificar plano e configurações; propor e validar ajustes autorizados. |
| Boot | Investigar inicialização, aplicativos e falhas; reparos exigem plano específico e aprovação. |
| Cache e espaço | Identificar categorias, caminhos e volume; apresentar prévia antes da limpeza; preservar dados pessoais. |
| Programas | Identificar produto, versão e origem; planejar instalação/desinstalação e verificar resultado. |
| Debian | Cobrir serviços, logs, inicialização, disco/cache e pacotes com documentação da versão instalada. |
| Rede | Diagnosticar interfaces, DNS, rotas, portas e conectividade; limitar a consulta aos alvos do atendimento. |

Cada procedimento deve declarar pré-requisitos, parâmetros, coleta inicial, comandos compatíveis, efeitos, validação e reversão quando viável. Comandos preestabelecidos devem ser parametrizados e revisados; não aplicar receitas universais de “otimização”.

## 3. Consolidação de ferramentas e fontes

Referência inicial: [MCP para administração de sistemas! — Tambotech](https://www.tambotech.com.br/tecnologia/mcp-comandos-rede-windows/). O inventário abaixo usa os projetos originais para conferir finalidade e limitações. Capacidades descritas não equivalem a testes de integração concluídos.

A intenção de um “fork de tudo junto” será atendida por **código e ferramentas selecionados incorporados ao próprio repositório**, mantendo origem identificável, e não apenas por uma coleção de links. Não será necessário fundir todos os servidores nem expor funções repetidas. Usar scripts diretamente quando adequado; MCP será uma interface possível para as capacidades operacionais.

Para cada incorporação, registrar origem, revisão/tag, licença, atribuições, dependências, modificações locais e atualização. Confirmar permissão de redistribuição antes de copiar código. Componentes sem licença esclarecida ficam pendentes; serviços documentais remotos são configurados pelo endpoint, sem presumir disponibilidade de seu código para incorporação.

### Documentação

| Fonte | Destinação |
|---|---|
| [Microsoft Learn MCP](https://learn.microsoft.com/en-us/training/support/mcp) | Prioridade obrigatória para Windows. Configurar `https://learn.microsoft.com/api/mcp`, via Streamable HTTP, sem autenticação; pesquisar e ler documentação oficial. |
| [man-mcp-server](https://github.com/guyru/man-mcp-server) | Candidato principal proposto para manuais locais do Debian; requer Linux, Python 3.10+, `man` e `apropos`. |
| [mansplain](https://github.com/bennypowers/mansplain) | Alternativa para man, GNU info, tldr e documentação Gentoo; selecionar apenas capacidades adicionais úteis. |
| [mcp-unix-manual](https://github.com/tizee/mcp-unix-manual) | Alternativa para descoberta e documentação de comandos; verificar exigência de Python 3.13+. |
| [mcp-redhat-manpage](https://github.com/sleepytimeshon/mcp-redhat-manpage) | Manuais versionados RHEL; complemento futuro, sem substituir referências Debian. |
| [Grafana Docs MCP](https://github.com/grafana/mcp-doc-server) | Servidor local de consulta documental; incluir se o atendimento envolver Grafana. |
| [AWS Knowledge MCP](https://awslabs.github.io/mcp/servers/aws-knowledge-mcp-server) | Complemento remoto para ambientes AWS; endpoint `https://knowledge-mcp.global.api.aws`. |
| [Mintlify Index](https://www.mintlify.com/docs/search-index/connect) | Busca documental ampla; avaliar cobertura e condições antes de configurar `https://index.mintlify.com/mcp`. |
| [xdocs](https://xdocs.dev/) · [código](https://github.com/Averyy/apple-dev-docs) | Documentação Apple independente; endpoint `https://xdocs.dev/mcp`. Inventariado, fora do MVP Windows/Debian. |
| [Context7](https://context7.com/) | Referência complementar para bibliotecas durante implementação; não é o núcleo de manutenção de SO. |

### Operação Windows

| Projeto | Avaliação para incorporação |
|---|---|
| [PoshMcp](https://github.com/usepowershell/PoshMcp) | Expõe scripts/cmdlets PowerShell. Exige .NET 10 e PowerShell 7; o README consultado deixa a licença pendente. Não incorporar até esclarecer licença e compatibilidade. |
| [powershell-mcp](https://github.com/IMRRD/powershell-mcp) | Execução PowerShell, serviços e conexão SSH/WinRM/SFTP; candidato local e remoto. |
| [windows-mcp-server](https://github.com/AhmedLaminou/windows-mcp-server) | Diagnóstico e manutenção local: processos, disco, limpeza, segurança e inicialização. Comparar cobertura com os seguintes. |
| [windows-admin-mcp](https://github.com/devladpopov/windows-admin-mcp) | Serviços, eventos, diagnóstico e auditoria; declara Windows 10/11, Node.js 18+ e PowerShell 5.1+. Avaliar primeiro para serviços/logs. |
| [windows-operations-mcp](https://github.com/sandraschi/windows-operations-mcp) | Serviços, Registro, eventos, tarefas e aplicações; selecionar funções complementares e controlar operações que modificam estado. |
| [win-mcp-server](https://github.com/Chillwind132/win-mcp-server) | Administração remota Windows por WinRM/NTLM; candidato da etapa remota. |

### Rede complementar

| Projeto | Avaliação para incorporação |
|---|---|
| [mcp-nettools — PyPI](https://pypi.org/project/mcp-nettools/) · [código](https://github.com/aaronckj/mcp-nettools) | **Preferência explícita do usuário.** Avaliar primeiro para DNS, portas, certificados e saúde de serviços. Python 3.12+; compatibilidade Windows a demonstrar. |
| [netops-mcp](https://github.com/alpadalar/netops-mcp) | Rede e recursos do sistema; documentação declara Linux/macOS e Windows não suportado. Considerar no perfil Debian. |
| [network-mcp](https://github.com/labeveryday/network-mcp) | Diagnóstico, PCAP e planejamento de rede; avaliar diferenças úteis frente ao preferido. |
| [mcp-network-tools](https://github.com/DomoticX/mcp-network-tools) | Interfaces, ARP, rotas e conexões, com API nativa Windows; licença de redistribuição ainda a confirmar. É diferente de `mcp-nettools`. |
| [Keel](https://github.com/seayniclabs/keel) | Diagnósticos de DNS/TLS/HTTP; alternativa. A instalação documentada é Python; não presumir binário independente. |

**Pendência observada:** PyPI e README GitHub de `mcp-nettools` anunciam conjuntos de ferramentas diferentes. Conferir correspondência entre pacote, código e versão antes da seleção; não prometer quantidade nem superioridade. Registrar sobreposições de ping, DNS, portas e traceroute e escolher um provedor por capacidade. Ferramentas com escrita HTTP ou outros efeitos não são diagnóstico somente leitura.

## 4. Regras centrais, personalidade e memória

Os nomes escolhidos pelo usuário são requisitos do projeto:

| Arquivo/localização proposta | Responsabilidade |
|---|---|
| `agent.md`, na raiz | Fonte central das regras e pipelines; determina leitura de `soul.md` e do estado da máquina. |
| `soul.md`, na raiz | Personalidade criativa e prudente descrita na seção 1, sem contrariar suas autorizações. |
| `.local/<nome-da-maquina>/memory.md` | Solicitações sanitizadas, contexto, decisões, autorizações delimitadas e pendências, atualizados continuamente. |
| `.local/<nome-da-maquina>/changelog.md` | Histórico cronológico do que realmente foi executado: data, ação/alvo, autorização, resultado, validação e eventual reversão. |

Identificar a máquina por seu nome, validar o nome para uso em caminho e resolver duplicidades sem misturar históricos. No remoto, a identificação corresponde à máquina atendida, não ao computador do técnico. Todo estado permanece dentro do projeto local e `.local/` fica excluída do Git. Versionar somente modelos vazios em `templates/`; não enviar dados das máquinas ao GitHub. O histórico dos atendimentos é distinto das notas de versões do produto, propostas em `docs/releases.md`.

Na preparação, solicitar autorização delimitada para criar/atualizar **somente os registros locais** durante o atendimento. Essa autorização não libera modificações do SO ou cópia de arquivos sensíveis. Autorizações no histórico não são permissões reutilizáveis para novas mudanças. Se negada, trabalhar sem persistência e informar a limitação. Não salvar credenciais, segredos ou logs brutos sensíveis.

No início da sessão: identificar máquina → carregar `agent.md` e `soul.md` → ler memória/histórico corretos. A cada pedido: registrar solicitação e decisões, distinguindo proposto, autorizado, executado e validado. Ao encerrar: registrar resultado e próximo passo, sem converter tentativa ou hipótese em execução bem-sucedida.

## 5. Pipelines do produto

### A. Preparação inicial

1. Receber o endereço do repositório e o cliente escolhido; detectar SO, versão, arquitetura, shell, runtimes, conectividade e privilégios disponíveis.
2. Apresentar plano de obtenção do projeto, dependências e alterações de configuração; obter autorização específica antes de qualquer instalação ou escrita.
3. Obter a versão escolhida e configurar o adaptador que carrega `agent.md`; preservar regras/configurações existentes. Apresentar conflitos em vez de sobrescrevê-los.
4. Preparar somente módulos pertinentes ao ambiente, configurar Microsoft Learn no perfil Windows e documentação local no Debian. Demais MCPs são condicionais.
5. Usar caminhos resolvidos e versões fixadas; preservar credenciais do técnico fora do repositório. Informar elevação ou reinício realmente necessários.
6. Em nova sessão, verificar leitura integral das regras centrais, personalidade e estado correto; testar espera de autorização sem realizar alteração. Verificar conexão MCP, ferramentas e consulta inofensiva. Repetir a preparação sem duplicar entradas ou perder configurações.

### B. Documentação e diagnóstico

Entender o sintoma → identificar máquina e escopo → coletar evidências necessárias em somente leitura → consultar documentação oficial/local da versão → apresentar hipóteses e plano. Evitar enviar dados privados nas consultas. Se uma fonte ficar indisponível, declarar a limitação e usar referências locais identificadas, sem inventar parâmetros.

### C. Correção e manutenção

Apresentar ação exata, alvos, efeito, risco e reversão → obter autorização → executar apenas o aprovado → comparar antes/depois → relatar resultado e pendências. Cópias de segurança e gravação de relatórios devem constar do plano autorizado. Se surgir ação adicional, falha ou necessidade de reinício, parar a sequência afetada e informar. Nunca simular aprovação chamando sozinho uma ferramenta de confirmação.

### D. Atendimento remoto

Confirmar destino, identidade, conectividade e acesso já disponível. Considerar SSH para Debian e mecanismos Windows compatíveis, como WinRM, conforme validação. Não presumir acesso administrativo remoto nem habilitá-lo silenciosamente. Aplicar a mesma política de autorização, proteção de arquivos e evidências do fluxo local.

### E. Atualização das incorporações

Revisar alterações do projeto de origem → conferir licença/dependências → comparar capacidades e permissões → testar em ambiente isolado → atualizar revisão, atribuições e histórico. Não substituir automaticamente uma versão validada por `latest` durante atendimento.

## 6. Adaptação aos ambientes de IA

`agent.md` é o nome central **customizado**, não um padrão universal. Os arquivos nativos serão adaptadores mínimos; não duplicar neles as regras de negócio. O cliente deve carregar integralmente o central e seguir seu protocolo de leitura de personalidade/memória. Uma referência textual isolada não comprova carregamento: verificar pelo diagnóstico/contexto do cliente ou leitura explícita registrada.

| Cliente | Adaptador de instruções e configuração MCP |
|---|---|
| **OpenCode** | `AGENTS.md` na raiz orienta o carregamento; adicionar `instructions: ["agent.md"]` ao `opencode.json` ou `opencode.jsonc` pelo mecanismo oficial. Referências dentro de `AGENTS.md` não são expandidas automaticamente. Gerar MCP e permissões conforme versão detectada: a V2 tem diferenças de estrutura. Fontes: [regras](https://opencode.ai/docs/rules/), [MCP](https://opencode.ai/docs/mcp-servers/), [V2](https://opencode.ai/v2/docs/mcp-servers), [permissões](https://opencode.ai/docs/permissions/). |
| **Codex local** | O nativo é `AGENTS.md`, plural e maiúsculo, não `codex.md`. Adaptador determina leitura integral de `./agent.md` antes de agir; não presumir importação automática por `@`. MCP em `.codex/config.toml` de projeto confiável ou `~/.codex/config.toml` do usuário, sob `mcp_servers.<nome>`. Fontes: [instruções](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [MCP](https://developers.openai.com/codex/mcp). |
| **VS Code + GitHub Copilot** | `.github/copilot-instructions.md` referencia `../agent.md`; habilitar/verificar `chat.includeReferencedInstructions` e conferir contexto efetivo. `AGENTS.md` também é suportado. MCP convencional em `.vscode/mcp.json`, chave `servers`; conferir formato se usar Agent Host. Outras extensões exigem adaptador específico: VS Code sozinho não é agente. Fontes: [instruções](https://code.visualstudio.com/docs/agent-customization/custom-instructions), [MCP](https://code.visualstudio.com/docs/agent-customization/mcp-servers), [permissões](https://code.visualstudio.com/docs/agents/run/security). |
| **Claude Code — Anthropic** | `CLAUDE.md` na raiz importa `agent.md` com `@agent.md` fora de bloco de código. MCP compartilhável em `.mcp.json`, chave `mcpServers`; permissões em `.claude/settings.json`. Não confundir Claude Code com o chat comum do Claude. Fontes: [memória/importação](https://code.claude.com/docs/en/memory), [MCP](https://code.claude.com/docs/en/mcp), [permissões](https://code.claude.com/docs/en/permissions). |
| **Antigravity IDE** | Regra Always On em `.agents/rules/brazilian-computer-guy.md`, com referência `@../../agent.md`. `~/.gemini/GEMINI.md` é o arquivo global documentado; não presumir equivalente na raiz. MCP atual em `.agents/mcp_config.json`, chave `mcpServers`; conferir versão, pois há formatos legados. Fontes: [regras](https://antigravity.google/docs/rules-workflows), [MCP](https://antigravity.google/docs/mcp), [permissões](https://antigravity.google/docs/permissions). |

Em todos: começar com leitura e configurar aprovação prévia para ferramentas mutáveis, shell e escrita, preservando restrições existentes. Não usar modos de bypass/autoaprovação; revisão posterior de alterações não equivale a consentimento prévio. Markdown orienta comportamento, mas não é uma barreira técnica infalível. Se o cliente não oferecer controles suficientes, limitar a diagnóstico e propostas para execução manual. Autenticação e modelo pertencem ao técnico; nenhum segredo será embutido.

## 7. Entregáveis e aceitação

**Estrutura proposta:** `README.md` para início rápido; arquivos centrais/estado da seção 4; adaptadores da seção 6; `procedimentos/windows`, `procedimentos/debian` e `procedimentos/rede`; `tools` e `vendor` para código incorporado; manifesto, matriz de compatibilidade, licenças/atribuições e modelo de relatório.

O agente implementador deve entregar uma primeira versão verificável, com os seguintes critérios:

1. Um técnico inicia pelo endereço do projeto, entende o fluxo em pt-BR e conclui preparação autorizada em ao menos uma combinação Windows e uma Debian documentadas.
2. Cada cliente tem adaptador e teste de leitura integral de `agent.md`, `soul.md` e estado correto; limitações ficam explícitas, sem declarar compatibilidade não testada.
3. Microsoft Learn responde a consulta documental e os manuais Debian correspondem ao ambiente; falha de consulta é informada corretamente.
4. Os sete casos de SO citados na seção 2 têm procedimento com diagnóstico, proposta, autorização, verificação e limites; rede permanece complementar.
5. Testes comprovam que negar autorização impede alterações; aprovação de diagnóstico não libera correção; mudança de alvo exige nova autorização; arquivos sensíveis não são copiados ou expostos automaticamente.
6. Preparação repetida preserva configurações; falta de privilégios ou runtime produz orientação específica, sem contorno silencioso das proteções.
7. Componentes incorporados têm origem/revisão/licença registradas, testes na plataforma declarada e nenhuma chave embutida; duplicações têm decisão documentada.
8. Memória e histórico persistem entre sessões sem misturar máquinas; registros exigem autorização delimitada, permanecem fora do Git e distinguem proposto, autorizado, executado e validado.

**A definir na implementação:** endereço e licença do projeto, versões exatas de Debian/Windows homologadas, composição final após testes e sequência de entrega do remoto. Esses pontos não alteram as decisões já fixadas: foco em SO, preferência por execução local, conteúdo pt-BR e autorização antes de alterações.
