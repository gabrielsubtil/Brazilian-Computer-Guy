# Pipeline: otimização do Windows por ajuste de Registro

**Identificador:** `PIPE-WIN-02`
**Idioma:** português do Brasil
**Escopo:** Windows 7, Windows 10 e Windows 11 (cliente desktop)
**Classe:** ajustes reversíveis de Registro; a maioria é por usuário
**Estado:** procedimento de suporte; nada é aplicado sem autorização explícita.

## Selo deste pipeline

- **Recomendado pelo fabricante (Microsoft)?** Em parte, e com honestidade: **poucos itens são oficialmente recomendados** (bloquear LLMNR, desligar o ID de publicidade, desligar experiências do consumidor). A maioria é apenas **permitida** — a Microsoft documenta o valor e não proíbe a alteração. Nenhum item aqui pode ser apresentado como “otimização recomendada pela Microsoft”.
- **Documentado oficialmente?** Para quase todos, sim, com fonte primária indicada item por item. O que não tem fonte primária está marcado.
- **Ganho esperado:** **pequeno**, e na maioria dos casos apenas perceptivo — latência de menu, animação, ruído de rede/telemetria. Nunca é ganho de processamento, de FPS, de boot ou de “internet mais rápida”.
- **Riscos:** alteração visual e de acessibilidade (quem depende de animação percebe), perda de conveniência (menus e buscas menos “inteligentes”), e ajustes de política que podem ser sobrescritos por domínio, MDM ou EDR.
- **Reversão:** sempre registrada; quase sempre apagar o valor ou voltar ao padrão.
- **É decisão do usuário?** **Sim.** O agente apresenta, pondera e pergunta. Nunca decide, nunca aplica sem confirmação explícita, nunca insiste depois de uma recusa.

## Regras inegociáveis

1. Comece em modo somente leitura; inventariar não autoriza mudar nada.
2. **Nunca prometa velocidade.** Nenhum ajuste desta pipeline aumenta processamento. Se o problema é lentidão real, o caminho é diagnosticar hardware, disco, memória e programas — não acumular chaves de Registro.
3. Exporte a chave ou crie ponto de restauração **antes** de cada alteração, e registre o valor anterior.
4. **Um ajuste por vez.** Nunca aplique um “pacote” de dez valores de uma vez: se algo quebrar, você não saberá o que foi.
5. Nunca altere Registro de segurança, atualização ou rede crítica para “ganhar desempenho”: Defender/Segurança do Windows, Firewall, Windows Update/BITS, RPC, DCOM, rede, drivers, logon, backup e recuperação.
6. Em máquina corporativa (domínio, MDM, EDR, política de suporte), não aplicar nada antes de confirmar a política; vários itens deste documento são políticas gerenciadas centralmente.
7. Itens das Classes C e D deste documento são **proibidos**. Se o usuário pedir um deles, explique o motivo com a fonte e não aplique.
8. Depois de qualquer aplicação: validar antes/depois, registrar e emitir o Relatório Técnico de Atendimento.

## 1. Triagem obrigatória (somente leitura)

- versão, edição, build e arquitetura do Windows, e situação de suporte;
- **queixa concreta e mensurável**: “menu demora a abrir”, “boot demorado”, “rede com tráfego constante”; sem isso não há o que otimizar;
- se a máquina é pessoal ou gerenciada (domínio, MDM, EDR, VPN, backup);
- se o usuário depende de recursos de acessibilidade (animações, contraste, tamanho de texto);
- **linha de base registrada**: contagem de processos, memória em uso, tempo de logon/boot, e a percepção do próprio usuário sobre a latência do menu.

Coleta somente leitura dos valores candidatos:

```powershell
reg query "HKCU\Control Panel\Desktop" /v MenuShowDelay
reg query "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v EnableMulticast
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry
Get-MpComputerStatus | Select-Object IsTamperProtected
```

Backup antes de alterar:

```powershell
reg export "HKCU\Control Panel\Desktop" "%USERPROFILE%\Desktop\bcg-backup-desktop.reg" /y
```

## 2. Catálogo por classe

### Classe A — permitido e documentado oficialmente

Ajustes de experiência e de privacidade. Não removem função do sistema; mudam aparência, latência de interface e ruído de rede.

| # | Ajuste | Chave e valor | Efeito e ganho | Reversão |
|---|---|---|---|---|
| A1 | Latência de submenu | `HKCU\Control Panel\Desktop` → `MenuShowDelay` (**REG_SZ**, “20” a “100”; padrão 400) | Reduz a espera antes de abrir submenus cascata. É o ajuste com o efeito mais perceptível. **Afeta só os menus Win32 legados** — no Windows 11 o menu Iniciar moderno (WinUI/XAML) ignora o valor. | Voltar para `400` |
| A2 | Animação de minimizar/maximizar | `HKCU\Control Panel\Desktop\WindowMetrics` → `MinAnimate` (REG_SZ `0`) | Janelas param de animar ao minimizar/restaurar. | `1` |
| A3 | Efeitos visuais globais | `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects` → `VisualFXSetting` (DWORD `2` = melhor desempenho; `1` = melhor aparência; `3` = personalizado) | Equivale a “Ajustar para obter melhor desempenho” nas Opções de Desempenho. **Remove sombras e suavização de fontes** — avise. | `1` ou `0` |
| A4 | LLMNR desligado | `HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient` → `EnableMulticast` (DWORD `0`) | Desliga a resolução de nomes por multicast. É **recomendado oficialmente** (baseline de segurança Microsoft) e tem efeito medido: zera as consultas LLMNR. Também reduz superfície de spoofing. | Apagar o valor |
| A5 | Rastreamento de execução de apps | `HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced` → `Start_TrackProgs` (DWORD `0`) | Windows para de registrar execuções para “melhorar” Iniciar e busca. Efeito: privacidade; leve redução de atividade. | `1` |
| A6 | Idioma enviado a sites | `HKCU\Control Panel\International\User Profile` → `HttpAcceptLanguageOptOut` (DWORD `1`) | Bloqueia uso da lista de idiomas para conteúdo “localmente relevante”. | Apagar |
| A7 | ID de publicidade | `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo` → `Enabled` (DWORD `0`) **e** `HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo` → `DisabledByGroupPolicy` (DWORD `1`) | Desliga o ID de publicidade (e o redefine). | `1` / apagar |
| A8 | Experiências do consumidor | `HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent` → `DisableWindowsConsumerFeatures` (DWORD `1`) **e** `HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent` → `DisableTailoredExperiencesWithDiagnosticData` (DWORD `1`) | Para de instalar/empurrar apps sugeridos e dicas “personalizadas”. É o ajuste que mais reduz ruído visual e instalação indesejada. | Apagar |
| A9 | Pedidos de feedback | `HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection` → `DoNotShowFeedbackNotifications` (DWORD `1`) | Windows para de pedir feedback. | Apagar |
| A10 | Apps em segundo plano | `HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy` → `LetAppsRunInBackground` (DWORD `2` = negar) | Bloqueia apps modernos em segundo plano. **Ressalva oficial:** alguns apps, incluindo Cortana e Busca, podem não funcionar como esperado. Preferir desligar app por app. | Apagar |

Fontes: A1 e A2 correspondem aos parâmetros `SPI_SETMENUSHOWDELAY` e `SPI_SETANIMATION` de `SystemParametersInfo`.[1] A4–A9 são chaves de política publicadas pela Microsoft.[2][3]

### Classe B — permitido, mas com efeito limitado ou condicionado

Informe a limitação antes de propor: o usuário precisa saber que talvez não mude nada.

| # | Ajuste | Limitação (por que pode não fazer efeito) |
|---|---|---|
| B1 | `HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection` → `AllowTelemetry` (DWORD `0`) | O valor `0` (“Sem dados”) **só tem efeito em Enterprise, Education e Server**. Em Home e Pro é equivalente a `1`. Documentado pela Microsoft.[2] |
| B2 | Bloqueio global de apps em segundo plano | No **Windows 11 21H2 e posteriores** a página global foi descontinuada; passou a ser por aplicativo.[4] |
| B3 | `HKLM\SYSTEM\CurrentControlSet\Control\FileSystem` → `NtfsDisableLastAccessUpdate` (via `fsutil behavior set disablelastaccess 1`) | **Na prática já está desabilitado por padrão** nos sistemas atuais (gerenciado pelo próprio NTFS). A própria documentação diz que o carimbo de último acesso raramente é gravado. Além disso, pode afetar Backup e Remote Storage.[5] Não prometa ganho. |

### Classe C — proibido: a Microsoft bloqueia ou reverte

Não são “proibidos por política do BCG”: são **tecnicamente anulados pelo Windows**. Aplicar gera a falsa impressão de que o ajuste valeu.

- **`DisableAntiSpyware` / `DisableAntivirus`** (desligar o Microsoft Defender): a Microsoft **removeu** essas chaves; a configuração é ignorada em dispositivos com plataforma 4.18.2108.4 ou superior, e alterações de Registro no Defender são bloqueadas pela **proteção contra adulteração (tamper protection)**, ativa por padrão no consumidor. A alteração pode até “parecer” bem-sucedida e não valer nada.[6][7]
- **Políticas de Windows Update** (`NoAutoUpdate` e correlatas): em Home/Pro o Windows Update ignora e reverte configurações locais, e o serviço de reparo (`WaaSMedicSvc`) desfaz alterações em serviços. Atualização é item de segurança: não é alvo desta pipeline.
- **Qualquer valor sob `HKLM\SOFTWARE\Microsoft\Windows Defender\...`** enquanto `IsTamperProtected` for `True`.

### Classe D — proibido: não faz o que promete, ou piora

Estes circulam em todo tutorial de “otimização”. A maioria é inútil e alguns pioram o sistema. **Confrontado com um pedido desses, corrija a informação com a fonte.**

| # | Ajuste popular | O que a documentação mostra |
|---|---|---|
| D1 | `SystemResponsiveness` = 0 (multimídia/jogos) | **Não faz nada.** A Microsoft documenta que valores abaixo de 10 e acima de 100 são **fixados em 20** — que já é o padrão. A tela mostra `0`, mas o comportamento é idêntico.[8] |
| D2 | `GPU Priority` e `SFIO Priority` nas tarefas de MMCSS | A própria referência diz **“not yet used”** e **“not used”**.[8] São dois dos valores mais repetidos em guias de jogos e nenhum tem efeito. |
| D3 | `LargeSystemCache` = 1 | Política **orientada a servidor de arquivos**: prioriza o cache de arquivos do sistema em detrimento do conjunto de trabalho dos programas. O Windows cliente usa `0` de propósito. Em máquina de uso interativo, tende a piorar — e o sintoma é exatamente o que o usuário queria corrigir.[9] |
| D4 | `EnablePrefetcher` / `EnableSuperfetch` | O valor recomendado é `3`; valores **acima de 3 não aumentam desempenho** e reduzir/desligar **piora** o tempo de abertura de programas. Deixe como está. |
| D5 | Limpar a pasta `Prefetch` | É uma **des-otimização temporária**: o Windows precisa recriar todos os arquivos de referência, atrasando o próximo boot e as próximas aberturas de programa. A pasta é autolimitada (128 entradas, poucos MB). |
| D6 | “Limpeza de Registro” e “otimizador de RAM” | Não há ganho de desempenho associado; otimizadores de memória movem dados para o arquivo de paginação e costumam **degradar** a responsividade. A limpeza de entradas órfãs é cosmética, não performance. |
| D7 | “Acelerar a internet” por Registro/TCP | Sem fonte primária que sustente; o ajuste automático da pilha TCP é o comportamento suportado. Só avaliar com medição e documentação específica do caso. |

> **Regra derivada:** qualquer ajuste de “desempenho” sem fonte primária da Microsoft, ou que prometa ganho de FPS/velocidade, é tratado como Classe D até prova documental em contrário.

## 3. Diferenças por versão

| Ajuste | Windows 7 | Windows 10 | Windows 11 |
|---|---|---|---|
| A1 MenuShowDelay, A2 MinAnimate, A3 VisualFXSetting | Existem | Existem | Existem; **não afetam o menu Iniciar moderno** |
| A4 LLMNR (`EnableMulticast`) | Não existe (chegou no Windows 8) | Sim | Sim |
| A5–A9 privacidade/CloudContent/AdvertisingInfo | Não existem | Sim | Sim |
| A10 background apps | Não existe | Sim | Global descontinuado (21H2+) |
| B1 `AllowTelemetry` | Não existe | Sim (efeito pleno só Enterprise) | Sim (idem) |
| D4 Prefetch | Sim, e é onde o mito nasceu | Sim | Sim |

O Windows 7 está **fora de suporte desde 14 de janeiro de 2020**. Otimizar Registro nele é paliativo: a orientação correta é migrar ou isolar a máquina.[10]

## 4. Proposta obrigatória antes de alterar

> **[PROPOSTA DE AJUSTE DE REGISTRO — BCG]**
> **Ação:** alterar `{CHAVE}` → `{VALOR}` de `{VALOR_ATUAL}` para `{VALOR_NOVO}` ({tipo}).
> **Classe:** A (permitido e documentado) — ou a ressalva correspondente.
> **Motivo:** `{sintoma medido do usuário}`
> **É recomendação da Microsoft?** `{Sim para A4/A7/A8, conforme baseline; caso contrário: “não — é permitido e documentado, não recomendado”}`
> **Fonte oficial:** `{link}`
> **Ganho esperado:** `{pequeno e do tipo X — sem promessa de velocidade}`
> **Efeitos colaterais:** `{aparência, acessibilidade, conveniência}`
> **Reversão:** `{valor anterior / apagar o valor / .reg exportado}`
>
> Mesmo com ganho pequeno e sem recomendação da Microsoft, aplicar ou não é **sua decisão**. Deseja autorizar **somente esta alteração**?

Se houver mais de um ajuste, apresente um por um, na ordem de menor risco (A1 e A2 primeiro). Nunca converta “otimize o Windows” em autorização para uma lista.

## 5. Validação e rollback

1. exporte a chave antes; anote o valor anterior;
2. aplique **um** ajuste;
3. quando o ajuste for de aparência/interface, basta encerrar e reabrir o `explorer.exe` ou sair e entrar de novo; só reinicie se necessário;
4. compare o que motivou a intervenção — tempo de menu, contagem de processos, memória, tráfego de rede — com aquilo que motivou o pedido;
5. valide que nada regrediu: som, vídeo, rede, impressora, acessibilidade, apps do usuário;
6. se houver regressão, importe o `.reg` exportado e pare para reavaliar;
7. registre no Relatório Técnico: valor anterior, valor novo, fonte, autorização, resultado medido e rollback.

## Sources

[1] https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-systemparametersinfoa — `SPI_SETMENUSHOWDELAY` (0x006B) e `SPI_SETANIMATION` (0x0049)
[2] https://learn.microsoft.com/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services — chaves de Registro oficiais de privacidade/telemetria, incluindo `AllowTelemetry`, `DisableWindowsConsumerFeatures`, `DisableTailoredExperiencesWithDiagnosticData`, `Start_TrackProgs`, `HttpAcceptLanguageOptOut`, `AdvertisingInfo`, `DoNotShowFeedbackNotifications`, `LetAppsRunInBackground`
[3] https://learn.microsoft.com/azure/governance/policy/samples/guest-configuration-baseline-windows — baseline de segurança: `EnableMulticast` recomendado como `Enabled` (LLMNR desligado)
[4] https://learn.microsoft.com/windows/apps/develop/launch/launch-settings — página global de apps em segundo plano descontinuada no Windows 11 21H2+
[5] https://learn.microsoft.com/windows-server/administration/windows-commands/fsutil-behavior e https://learn.microsoft.com/openspecs/windows_protocols/ms-fsa/4e3695bd-7574-4f24-a223-b4679c065b63 — último acesso e política do NTFS
[6] https://learn.microsoft.com/windows-hardware/customize/desktop/unattend/security-malware-windows-defender-disableantispyware — `DisableAntiSpyware` removido e ignorado
[7] https://learn.microsoft.com/defender-endpoint/tamper-protection-overview — alterações de Registro no Defender bloqueadas pela proteção contra adulteração
[8] https://learn.microsoft.com/windows/win32/procthread/multimedia-class-scheduler-service — `SystemResponsiveness` (clamp em 20), `GPU Priority` (“not yet used”), `SFIO Priority` (“not used”)
[9] https://learn.microsoft.com/windows/win32/memory/memory-limits-for-windows-releases — `LargeSystemCache` e espaço de endereço do cache do sistema
[10] https://learn.microsoft.com/lifecycle/products/windows-7 — fim de suporte do Windows 7

> Itens de Classe D4 e D5 (Prefetch/Superfetch) vêm de orientação consolidada de engenharia sobre o gerenciador de prefetch; não há página única da Microsoft que os consolide — **trate como fonte secundária** e não os apresente ao usuário como citação oficial.
