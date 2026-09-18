#!/usr/bin/env bash
# Coleta de Diagnóstico Completo do Sistema (Somente Leitura) — Debian
# Brazilian Computer Guy

set -e

echo "===================================================="
echo " BRAZILIAN COMPUTER GUY — DIAGNÓSTICO DEBIAN "
echo "===================================================="

echo -e "\n[+] Informações Gerais:"
echo "  Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"
echo "  Hostname: $(hostname)"
echo "  Kernel: $(uname -r)"
echo "  Distribuição: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')"
echo "  Uptime: $(uptime -p)"

echo -e "\n[+] Memória e Swap:"
free -h

echo -e "\n[+] Armazenamento (Partições Principais):"
df -h -x tmpfs -x devtmpfs

echo -e "\n[+] Unidades Systemd em Falha:"
FAILED_COUNT=$(systemctl --failed --no-legend | wc -l)
if [ "$FAILED_COUNT" -eq 0 ]; then
    echo "  Nenhuma unidade com falha detectada. (OK)"
else
    systemctl --failed --no-pager
fi

echo -e "\n[+] Erros Críticos Recentes no Journald (Últimas 24h):"
journalctl -b 0 -p err..emerg --no-pager -n 10 || echo "  Sem acesso a journalctl ou sem erros."

echo -e "\nDiagnóstico concluído em modo SOMENTE LEITURA."
