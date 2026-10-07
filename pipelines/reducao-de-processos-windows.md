# Pipeline: redução segura de processos no Windows

**Identificador:** `PIPE-WIN-01`
**Idioma:** português do Brasil
**Escopo:** Windows 7, Windows 10 e Windows 11
**Estado:** procedimento de suporte; não executar alterações sem autorização explícita.

## Quando usar

Use este pipeline quando o usuário pedir para “reduzir processos”, acelerar a inicialização, diminuir consumo de CPU/RAM/disco em segundo plano ou identificar programas que abrem junto com o Windows.

**Objetivo:** reduzir carga de aplicativos e inicializações de terceiros que não sejam necessários, preservando segurança, rede, atualizações, drivers, recuperação e funções usadas pelo cliente. Não existe meta universal de “quantos processos” um Windows deve ter.

## Regras inegociáveis

1. Comece em modo somente leitura; inventariar não autoriza mudar nada.
2. Não encerre processos aleatoriamente, não aplique debloaters/listas genéricas e não delete entradas de Registro, tarefas ou serviços.
3. Priorize: aplicativo de terceiros no logon → permissão de app em segundo plano → tarefa de terceiro → serviço de terceiro. Serviços Windows só entram em análise individual, com dependências verificadas.
4. **Nunca proponha desativar para obter desempenho:** Microsoft Defender/Segurança do Windows, Firewall, Windows Update, BITS, RPC, RPC Endpoint Mapper, DCOM, DHCP Client, DNS Client, Network Location Awareness, Plug and Play, Event Log, serviços de drivers/armazenamento/energia, logon/perfil, backup ou recuperação.
5. Para cada mudança aprovada, altere uma entrada ou um grupo funcional pequeno, reinicie quando necessário, valide e registre como reverter.
6. Em dispositivo corporativo, confirme política de domínio, MDM, EDR, VPN, backup e suporte antes de alterar qualquer item.

## 1. Triagem obrigatória

Antes de falar em reduzir processos, colete:

- edição, versão, build, arquitetura e situação de suporte do Windows;
- sintoma mensurável: tempo de logon, consumo de CPU/RAM/disco, travamento, bateria ou processo específico;
- momento do problema: boot, logon, ocioso, aplicativo aberto ou rede conectada;
- software de segurança, ferramentas corporativas e periféricos relevantes;
- se o usuário precisa de sincronização, notificações, VPN, impressora, áudio, drivers do fabricante ou acesso remoto.

### Coleta somente leitura — Windows 10/11

```powershell
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber, OsArchitecture

Get-Process |
  Sort-Object CPU -Descending |
  Select-Object -First 25 ProcessName, Id, CPU, WorkingSet64, Path

Get-CimInstance Win32_StartupCommand |
  Select-Object Name, Command, Location, User

Get-ScheduledTask |
  Where-Object { $_.State -ne 'Disabled' } |
  Select-Object TaskName, TaskPath, State
```

### Coleta somente leitura — Windows 7

Windows 7 pode não ter os cmdlets modernos usados no Windows 10/11. Use WMI/PowerShell disponível no sistema:

```powershell
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"

Get-Process |
  Sort-Object CPU -Descending |
  Select-Object -First 25 ProcessName, Id, CPU, WorkingSet, Path

Get-WmiObject Win32_StartupCommand |
  Select-Object Name, Command, Location, User

Get-WmiObject Win32_Service |
  Select-Object Name, DisplayName, State, StartMode, PathName
```

Se a versão do PowerShell ou um provedor não suportar um comando, informe a limitação; não substitua por uma alteração de Registro ou serviço sem novo plano.

## 2. Classificação antes de propor mudança

Para cada candidato, registre:

- nome, caminho completo, editor/assinatura, versão e usuário associado;
- tipo: inicialização, aplicativo em segundo plano, tarefa agendada, serviço ou processo temporário;
- função para o cliente e consequência de não iniciar automaticamente;
- consumo observado e quando ocorreu;
- dependências conhecidas e forma de reversão.

Classifique assim:

| Classe | Conduta |
|---|---|
| Sistema, driver, segurança, rede, atualização, backup ou recuperação | Não alterar por este pipeline; investigar somente com procedimento específico. |
| Aplicativo de terceiro usado raramente | Candidato preferencial para desativar somente a inicialização automática. |
| Sincronizador/notificador de terceiro | Confirmar perda de sincronização/notificação antes de propor ajuste. |
| Tarefa ou serviço de terceiro | Identificar fabricante, função, dependências e reversão; preferir Manual a Disabled quando fizer sentido. |
| Desconhecido, sem assinatura ou caminho suspeito | Não “otimizar”; tratar como possível incidente e seguir diagnóstico de segurança. |

## 3. Caminho recomendado por versão

### Windows 10 e Windows 11

1. Comece por **Configurações > Aplicativos > Inicialização** ou pelo **Gerenciador de Tarefas > Aplicativos de inicialização**. O Gerenciador mostra o impacto de inicialização para ajudar a priorizar.[1]
2. Para aplicativos compatíveis, revise a atividade em segundo plano em **Configurações > Aplicativos > Aplicativos instalados > Opções avançadas**. `Nunca` reduz atividade, mas também impede notificações e atualizações daquele aplicativo; apps desktop tradicionais podem exigir ajuste no próprio aplicativo.[2]
3. Só depois de identificar um aplicativo específico, revise `shell:startup`, `shell:common startup` ou a entrada de inicialização correspondente. Registro não é primeira opção; qualquer alteração direta exige backup e alvo identificado.[1]

### Windows 7

1. Trate como legado e confirme se a máquina pode ser migrada ou isolada: o suporte terminou em 14 de janeiro de 2020.[4]
2. Use `msconfig` como diagnóstico temporário para isolar conflitos de serviços e inicialização de terceiros; documente tudo que for desmarcado.
3. Use pastas Startup e entradas de inicialização apenas com identificação precisa. Não transplante interfaces ou procedimentos do Windows 10/11 para o Windows 7.
4. Ao terminar o diagnóstico, restaure a inicialização normal ou deixe documentada a exceção autorizada.

### Windows 10 em 2026

Windows 10 Home/Pro 22H2 encerrou suporte em 14 de outubro de 2025; edições LTSC e programas ESU têm ciclos próprios. Reduzir processos não substitui plano de atualização, migração ou isolamento.[6]

### Windows 11

Use os mesmos princípios do Windows 10, mas confirme versão/edição e ciclo de suporte antes de qualquer orientação de manutenção. Não presuma que uma opção de interface existe em todas as versões.

## 4. Diagnóstico ampliado: Autoruns

Quando as interfaces normais não explicarem a inicialização, **Autoruns** (Microsoft Sysinternals) pode inventariar entradas de logon, Registro, tarefas, serviços, drivers, Winlogon e outros pontos de autoexecução.[3]

Uso seguro:

1. começar por inventário, filtros e verificação de assinatura/caminho;
2. investigar entradas não Microsoft e de terceiros antes de qualquer ação;
3. desmarcar, nunca excluir, uma entrada confirmada por vez;
4. registrar estado anterior e validar após reiniciar;
5. não usar recursos que enviem hashes/arquivos a serviços externos sem autorização específica.

## 5. Inicialização limpa: somente para isolamento

Para Windows 10/11, a inicialização limpa serve para identificar conflito de aplicativo ou serviço de terceiros: ocultar serviços Microsoft, testar em grupos e restaurar o estado normal após localizar a causa.[5]

Ela **não** é uma “otimização permanente”. O agente deve:

- explicar que recursos podem ficar temporariamente indisponíveis;
- registrar os itens desativados antes da reinicialização;
- pedir autorização separada antes de executar `msconfig` ou alterar serviços;
- reativar os itens necessários e documentar o responsável encontrado.

## 6. Proposta obrigatória antes de alterar

Use este modelo após o diagnóstico:

> **[PROPOSTA DE REDUÇÃO DE PROCESSOS — BCG]**
> **Ação:** desativar a inicialização automática de `{APLICATIVO_DE_TERCEIRO}`.
> **Alvo:** `{localização exata: Startup / tarefa / configuração do aplicativo}`.
> **Evidência:** `{consumo, impacto de inicialização e função confirmada}`.
> **Efeito esperado:** o aplicativo deixa de iniciar no logon; poderá ser aberto manualmente.
> **Riscos:** `{notificações, sincronização ou função que deixará de ocorrer}`.
> **Reversão:** reativar a mesma entrada em `{interface/caminho}`.
>
> Deseja autorizar **somente essa alteração**?

Se houver mais de um candidato, apresente-os separadamente. Não converta “otimize o PC” em autorização para mudar vários itens.

## 7. Validação e rollback

Após uma alteração autorizada:

1. confirme o estado da entrada alterada;
2. reinicie apenas se a mudança exigir ou se o usuário autorizar;
3. valide logon, rede, segurança, áudio, periféricos e aplicativo afetado;
4. compare a métrica que motivou a intervenção;
5. se houver regressão, aplique a reversão registrada e pare para reavaliar;
6. registre no relatório técnico: evidência inicial, autorização, comando/interface usada, antes/depois, resultado e rollback.

Para diagnóstico de conflito no Windows 10/11, a Microsoft orienta voltar à inicialização normal após a inicialização limpa.[5]

## Histórico e diferenças resumidas

| Tema | Windows 7 | Windows 10 | Windows 11 |
|---|---|---|---|
| Situação | Legado; suporte encerrado | Home/Pro 22H2 fora de suporte geral desde 14/10/2025 | Versão/edição definem suporte atual |
| Primeiro caminho | `msconfig`, Startup e inventário | Configurações/Task Manager > Inicialização | Configurações/Task Manager > Inicialização |
| Apps em segundo plano | Sem o mesmo controle moderno por aplicativo | Controles para apps compatíveis | Controles para apps compatíveis |
| Postura BCG | Diagnóstico compatível, migração/isolamento como prioridade | Manter segurança e avaliar ESU/migração | Manter versão suportada e evitar mudanças cegas |

## Sources

[1] https://support.microsoft.com/en-us/windows/experience/startup-boot/configure-startup-applications-in-windows
[2] https://support.microsoft.com/en-us/windows/privacy/windows-background-apps-and-your-privacy
[3] https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns
[4] https://learn.microsoft.com/en-us/lifecycle/products/windows-7
[5] https://support.microsoft.com/en-US/topic/how-to-perform-a-clean-boot-in-windows-da2f9573-6eec-00ad-2f8a-a97a1807f3dd
[6] https://learn.microsoft.com/en-us/lifecycle/products/windows-10-home-and-pro
