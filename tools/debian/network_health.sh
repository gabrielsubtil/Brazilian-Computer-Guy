#!/usr/bin/env bash
# Diagnóstico de Rede (Somente Leitura) — Debian
# Brazilian Computer Guy

TARGET_HOST=${1:-"1.1.1.1"}
TEST_DOMAIN=${2:-"debian.org"}

echo "--- Testando Conectividade de Rede (Debian) ---"

# 1. Loopback
if ping -c 2 127.0.0.1 >/dev/null 2>&1; then
    echo "1. Pilha TCP/IP Local (127.0.0.1): OK"
else
    echo "1. Pilha TCP/IP Local (127.0.0.1): FALHA"
fi

# 2. Gateway
GW=$(ip route | grep default | awk '{print $3}' | head -n 1)
if [ -n "$GW" ]; then
    if ping -c 2 "$GW" >/dev/null 2>&1; then
        echo "2. Gateway Padrão ($GW): OK"
    else
        echo "2. Gateway Padrão ($GW): SEM RESPOSTA"
    fi
else
    echo "2. Gateway Padrão: Não encontrado"
fi

# 3. Internet IP
if ping -c 2 "$TARGET_HOST" >/dev/null 2>&1; then
    echo "3. Conectividade Internet IP ($TARGET_HOST): OK"
else
    echo "3. Conectividade Internet IP ($TARGET_HOST): FALHA"
fi

# 4. Resolução DNS
if getent hosts "$TEST_DOMAIN" >/dev/null 2>&1; then
    echo "4. Resolução de Nomes DNS ($TEST_DOMAIN): OK"
else
    echo "4. Resolução de Nomes DNS ($TEST_DOMAIN): FALHA"
fi
