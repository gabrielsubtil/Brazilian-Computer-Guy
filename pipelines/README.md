# Pipelines — formato, selo e checklist

Esta pasta reúne **pipelines**: fluxos de decisão longos, com regras inegociáveis, triagem obrigatória,
proposta padronizada e rollback. Não confundir com `procedimentos/`, que são Procedimentos Operacionais
Padronizados (SOP) por área — “como fazer uma tarefa” (serviço, DNS, GRUB, energia).

> **Nota de nomenclatura:** a seção 5 do `Brazilian-Computer-Guy-PRD.md` também usa a palavra
> “pipelines” para os fluxos de produto (preparação, diagnóstico, correção, atendimento remoto,
> atualizações). Aquele é outro conceito. Nesta pasta, pipeline = fluxo de suporte sobre um tema.

## Quando criar uma pipeline (e não um procedimento)

Use `pipelines/` quando o assunto exigir **decisão, não só execução**:

- há regras que o agente não pode violar, mesmo que o usuário peça;
- existe uma classe de ações que deve ser recusada com justificativa;
- o tema é alvo frequente de desinformação na internet;
- a conversa tem várias etapas: triagem → proposta → autorização → execução → validação → rollback.

Use `procedimentos/` quando for uma tarefa pontual de uma área, sem política própria.

## Estrutura obrigatória

1. **Cabeçalho:** identificador (`PIPE-<PLATAFORMA>-<NN>`), idioma, escopo por versão, classe/risco, estado.
2. **Selo** (bloco abaixo).
3. **Regras inegociáveis**, numeradas — o que vale mesmo sem autorização para o resto.
4. **Triagem obrigatória somente leitura**, com os comandos de coleta e o backup necessário.
5. **Corpo técnico:** o catálogo, o caminho por versão, ou o que o tema exigir.
6. **Proposta obrigatória:** modelo preenchível que o agente apresenta antes de alterar qualquer coisa.
7. **Validação e rollback:** como medir antes/depois e como desfazer.
8. **Sources:** links das fontes primárias, numerados, referenciados no texto.

## Selo obrigatório (copiar em toda pipeline nova)

- **Recomendado pelo fabricante?** Sim / Não / Em parte — e dizer exatamente quais itens.
- **Documentado oficialmente?** Sim / Não — e o que não tem fonte primária precisa estar marcado.
- **Ganho esperado:** tamanho real do ganho, sem exagero. Se o ganho é pequeno, escreva pequeno.
- **Riscos e efeitos colaterais:** o que se perde.
- **Reversão:** como desfazer.
- **É decisão do usuário?** Sim — o agente apresenta, pondera e pergunta; nunca decide nem insiste depois de uma recusa.

## Checklist para incluir uma pipeline nova

1. Criar `pipelines/<nome>.md` seguindo a estrutura acima, com o selo preenchido.
2. Registrar na **matriz de procedimentos** do `agent.md`, seção 4 (tabela área → arquivo).
3. Adicionar o **gatilho na Fase 1** do `agent.md`: “se o pedido envolver X, carregar obrigatoriamente `pipelines/Y.md`”.
4. Espelhar o gatilho em `geminai.md` (hoje a lista de gatilhos é duplicada).
5. Atualizar a árvore de estrutura do `README.md`.
6. Documentar a mudança em `docs/releases.md`.

Os passos 2 e 3 são os que costumam faltar — sem eles a pipeline existe no repositório e nunca é carregada.

## Pipelines disponíveis

| Identificador | Arquivo | Tema |
|---|---|---|
| `PIPE-WIN-01` | [reducao-de-processos-windows.md](./reducao-de-processos-windows.md) | Redução segura de processos no Windows, incluindo o ajuste condicionado do limiar de agrupamento de serviços (`SvcHostSplitThresholdInKB`) |
| `PIPE-WIN-02` | [otimizacao-registro-windows.md](./otimizacao-registro-windows.md) | Otimização do Windows por ajuste de Registro, em quatro classes (permitido, limitado, bloqueado e ineficaz) |
