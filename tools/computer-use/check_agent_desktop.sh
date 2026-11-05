#!/usr/bin/env bash
# Brazilian Computer Guy (BCG) — Verificação da camada Computer Use.
# SOMENTE LEITURA: não instala, não configura e não dirige a interface.
# Referência: ../../docs/computer-use.md
# agent-desktop: Vercel Labs, Apache-2.0 — https://github.com/vercel-labs/agent-desktop
set -uo pipefail

checks=(); levels=(); oks=0; warns=0; fails=0
red=''; yellow=''; green=''; reset=''
if [[ -t 1 ]]; then
    red=$'\033[31m'; yellow=$'\033[33m'; green=$'\033[32m'; reset=$'\033[0m'
fi
record() {
    levels+=("$1"); checks+=("$2: $3")
    printf '%s[%s] %s: %s%s\n' "$4" "$1" "$2" "$3" "$reset"
}
ok() { oks=$((oks + 1)); record OK "$1" "$2" "$green"; }
warn() { warns=$((warns + 1)); record AVISO "$1" "$2" "$yellow"; }
fail() { fails=$((fails + 1)); record FALHA "$1" "$2" "$red"; }
summary() {
    printf '\n[+] Matriz de verificações:\n'
    local i
    for ((i=0; i<${#checks[@]}; i++)); do printf '%-6s | %s\n' "${levels[i]}" "${checks[i]}"; done
    printf 'Resumo: OK=%s | AVISO=%s | FALHA=%s\n' "$oks" "$warns" "$fails"
    printf 'Diagnóstico concluído em modo SOMENTE LEITURA.\n'
}
# Limite por processo, sem arquivos temporários. macOS pode não ter timeout.
run() {
    if command -v timeout >/dev/null 2>&1; then timeout -k 2 20 "$@" 2>&1
    elif command -v gtimeout >/dev/null 2>&1; then gtimeout -k 2 20 "$@" 2>&1
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c 'import os,signal,subprocess,sys
p=subprocess.Popen(sys.argv[1:],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,start_new_session=True)
try:
 out,_=p.communicate(timeout=20); sys.stdout.buffer.write(out); sys.exit(p.returncode)
except subprocess.TimeoutExpired:
 os.killpg(p.pid,signal.SIGKILL); p.communicate(); sys.exit(124)' "$@" 2>&1
    else return 125
    fi
}
# Os dois leitores aceitam o envelope {ok,data/error}; nunca exibem nomes de apps.
parse() {
    local mode=$1
    if [[ $parser == jq ]]; then
        jq -er --arg mode "$mode" '
          if type=="object" and .ok==false then error("comando recusado") else . end |
          (if type=="object" and has("data") then .data else . end) |
          if $mode=="status" then
            if (.platform|type)!="string" or (.supported_surfaces|type)!="array" then error("formato") else
              .platform, (.supported_surfaces|length), (.permissions // {} | tojson) end
          elif $mode=="apps" then
            (if type=="array" then . else .apps end) |
            if type=="array" then length else error("formato") end
          else (.permissions // .) |
            if type!="object" and type!="array" then error("formato") else
              tojson, ([.. | scalars | select(.==false or .=="denied" or .=="not_granted" or .=="unknown" or .=="not_determined" or .=="restricted")]|length) end
          end' 2>/dev/null
    elif [[ $parser == python3 ]]; then
        python3 -c 'import json,sys
try:
 d=json.load(sys.stdin)
 if isinstance(d,dict) and d.get("ok") is False: raise ValueError()
 if isinstance(d,dict): d=d.get("data",d)
 mode=sys.argv[1]
 if mode=="status":
  assert isinstance(d["platform"],str) and isinstance(d["supported_surfaces"],list)
  print(d["platform"]); print(len(d["supported_surfaces"])); print(json.dumps(d.get("permissions",{}),ensure_ascii=False))
 elif mode=="apps":
  a=d if isinstance(d,list) else d["apps"]; assert isinstance(a,list); print(len(a))
 else:
  p=d.get("permissions",d) if isinstance(d,dict) else d
  assert isinstance(p,(dict,list))
  def leaves(v):
   if isinstance(v,dict):
    for x in v.values(): yield from leaves(x)
   elif isinstance(v,list):
    for x in v: yield from leaves(x)
   else: yield v
  print(json.dumps(p,ensure_ascii=False))
  print(sum(v is False or isinstance(v,str) and v in ("denied","not_granted","unknown","not_determined","restricted") for v in leaves(p)))
except Exception: sys.exit(1)' "$mode" 2>/dev/null
    else return 1
    fi
}
# Extrai o envelope JSON mesmo quando o launcher npm imprime um aviso antes dele.
envelope() {
    local v=$1
    if [[ $v == \{* ]]; then printf '%s' "$v"; return; fi
    if [[ $v == *\{* ]]; then printf '{%s' "${v#*\{}"; return; fi
    printf '%s' "$v"
}
# Extrai um campo de topo do envelope: $1 = seção (data|error), $2 = chave.
# Nunca imprime nada em caso de falha; usado só para version e error.code.
json_field() {
    if [[ $parser == jq ]]; then printf '%s' "$1" | jq -er --arg s "$2" --arg k "$3" '.[$s][$k] // empty' 2>/dev/null
    elif [[ $parser == python3 ]]; then
        printf '%s' "$1" | python3 -c 'import json,sys
try:
 sec=json.load(sys.stdin).get(sys.argv[1],{})
 v=sec.get(sys.argv[2]) if isinstance(sec,dict) else None
 print("" if v is None else v)
except Exception: pass' "$2" "$3" 2>/dev/null
    fi
}
printf '====================================================\n BRAZILIAN COMPUTER GUY — COMPUTER USE\n SOMENTE LEITURA\n====================================================\n'
if ! command -v agent-desktop >/dev/null 2>&1; then
    fail Binário 'agent-desktop não encontrado no PATH. Instalação manual: npm install -g agent-desktop'
    summary; exit 2
fi
ok Binário 'agent-desktop encontrado no PATH'
for tool in node npm; do
    if command -v "$tool" >/dev/null 2>&1; then
        value=$(run "$tool" --version); rc=$?
        if [[ $rc -ne 0 ]]; then warn "$tool" "Não foi possível consultar a versão (código $rc)"
        elif [[ $tool == node ]]; then
            if [[ $value =~ ^v?([0-9]+)\. ]] && (( BASH_REMATCH[1] >= 18 )); then ok Node.js "$value (>= 18)"
            else warn Node.js "$value; esperado >= 18 (informativo)"; fi
        else ok npm "$value (informativo)"; fi
    else warn "$tool" 'Não encontrado no PATH (informativo)'; fi
done
parser=none
if command -v jq >/dev/null 2>&1; then parser=jq
elif command -v python3 >/dev/null 2>&1; then parser=python3; warn JSON 'jq ausente; usando python3'
else warn JSON 'jq e python3 ausentes; status/permissões brutos, contagem indisponível'; fi
raw=$(run agent-desktop version); rc=$?
value=$(envelope "$raw")
if [[ $rc -eq 0 ]]; then
    ver=$(json_field "$value" data version)
    if [[ -n $ver ]]; then ok Versão "$ver"
    else ok Versão "$value"; fi
else fail Versão "Consulta falhou (código $rc; 124=timeout, 125=sem limitador)"; fi
acc_denied=0
for cmd in status permissions list-apps; do
    raw=$(run agent-desktop "$cmd"); rc=$?
    value=$(envelope "$raw")
    if [[ $rc -ne 0 ]]; then
        code=$(json_field "$value" error code)
        if [[ $cmd == list-apps && ${acc_denied:-0} == 1 && ${code:-} == PLATFORM_NOT_SUPPORTED ]]; then
            warn "list-apps" "Recusado (${code}); coerente com acessibilidade negada e sem sessão gráfica"
        else
            fail "$cmd" "Consulta falhou (código $rc${code:+; $code}; detalhes omitidos por privacidade)"
        fi
        continue
    fi
    if [[ $parser == none ]]; then
        if [[ $cmd != list-apps ]]; then printf '[+] %s (JSON bruto):\n%s\n' "$cmd" "$value"; fi
        warn "$cmd" 'JSON não validado; list-apps nunca é exibido'; continue
    fi
    mode=$cmd; [[ $cmd == list-apps ]] && mode=apps
    parsed=$(printf '%s' "$value" | parse "$mode"); rc=$?
    if [[ $rc -ne 0 ]]; then fail "$cmd" 'Erro no envelope JSON ou formato não reconhecido'; continue; fi
    case $cmd in
        status)
            platform=${parsed%%$'\n'*}; rest=${parsed#*$'\n'}; surfaces=${rest%%$'\n'*}
            ok Plataforma "$platform"
            if (( surfaces > 0 )); then ok Acessibilidade "supported_surfaces=$surfaces (disponível; não prova acesso a todo app)"
            else warn Acessibilidade 'supported_surfaces vazio'; fi
            printf '[+] Permissões do status: %s\n' "${rest#*$'\n'}"
            [[ ${rest#*$'\n'} == *'"denied"'* || ${rest#*$'\n'} == *'"state": "denied"'* ]] && acc_denied=1
            ;;
        permissions)
            printf '[+] Permissões: %s\n' "${parsed%$'\n'*}"
            if [[ ${parsed##*$'\n'} -gt 0 || ${parsed%$'\n'*} == '{}' || ${parsed%$'\n'*} == '[]' ]]; then
                warn Permissões 'Pendentes, negadas, desconhecidas ou não informadas; revisar os valores acima'
            else ok Permissões 'Consulta válida; revisar requisitos específicos da plataforma'; fi
            ;;
        list-apps) ok list-apps "Aplicativos listados: $parsed (nomes omitidos)" ;;
    esac
done
case $(uname -s) in
    Linux)
        if [[ -z ${DISPLAY:-} && -z ${WAYLAND_DISPLAY:-} ]]; then warn Sessão 'DISPLAY e WAYLAND_DISPLAY ausentes; sessão gráfica não comprovada'
        else ok Sessão 'DISPLAY ou WAYLAND_DISPLAY presente (heurística)'; fi
        # Leitura sem executar /etc/os-release como código.
        distro=''; release=''
        if [[ -r /etc/os-release ]]; then
            while IFS='=' read -r key val; do
                val=${val#\"}; val=${val%\"}
                case $key in ID) distro=$val ;; VERSION_ID) release=$val ;; esac
            done < /etc/os-release
        fi
        if [[ $distro == ubuntu && $release =~ ^([0-9]+)\.([0-9]+)$ ]] &&
           (( BASH_REMATCH[1] > 24 || (BASH_REMATCH[1] == 24 && 10#${BASH_REMATCH[2]} >= 4) )); then
            ok Distribuição 'Ubuntu 24.04+; alvo oficial, não equivale a teste de compatibilidade'
        else warn Distribuição "${distro:-desconhecida} ${release}: Debian não homologado; somente Ubuntu 24.04+ é alvo oficial Linux"; fi
        ;;
    Darwin) warn Plataforma 'macOS: suportado pelo upstream, fora do escopo atual de homologação BCG' ;;
esac
if [[ -e ${HOME:-}/.agent-desktop || -L ${HOME:-}/.agent-desktop ]]; then
    if [[ -L ${HOME:-}/.agent-desktop || ! -d ${HOME:-}/.agent-desktop ]]; then warn Estado 'Estado não é diretório comum (ou é link simbólico); revisar manualmente'
    else
        mode=$(stat -c '%a' "$HOME/.agent-desktop" 2>/dev/null || stat -f '%Lp' "$HOME/.agent-desktop" 2>/dev/null)
        if [[ $mode == 700 ]]; then ok Estado '~/.agent-desktop com modo 700'
        else warn Estado "~/.agent-desktop: modo ${mode:-indisponível}; esperado 700 (nenhuma correção aplicada)"; fi
    fi
else ok Estado '~/.agent-desktop ausente; nada criado'; fi
summary
if (( warns + fails > 0 )); then exit 1; fi
exit 0
