#!/bin/bash
# health-check.sh - Verifica a saúde do sistema
# Uso: ./health-check.sh

# ---- Configuração ----
LIMITE=80                         # Alerta quando o uso passar de 80%
SERVICOS="cron NetworkManager"    # Serviços que devem estar rodando
PROBLEMAS=0                       # Contador de problemas encontrados

echo "===== Health Check: $(hostname) ====="
echo "Data: $(date '+%d/%m/%Y %H:%M')"
echo

# ---- 1. Disco ----
# df -h /        -> Mostra o uso da partição principal
# awk 'NR==2'    -> Pega só a 2ª linha (a 1ª é o cabeçalho)
# tr -d '%'      -> Tira o símbolo de %
USO_DISCO=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$USO_DISCO" -gt "$LIMITE" ]; then
    echo "[ALERTA] Disco: ${USO_DISCO}% usado"
    PROBLEMAS=$((PROBLEMAS + 1))
else
    echo "[OK]     Disco: ${USO_DISCO}% usado"
fi

# ---- 2. Memória ----
# free           -> Mostra o uso da memória RAM
# NR==2          -> Pega só a 2ª linha (a da memória RAM)
# $3 / $2 * 100  -> Memória usada ÷ total × 100 = porcentagem
USO_MEMORIA=$(free | awk 'NR==2 {printf "%d", $3 / $2 * 100}')

if [ "$USO_MEMORIA" -gt "$LIMITE" ]; then
    echo "[ALERTA] Memória: ${USO_MEMORIA}% usada"
    PROBLEMAS=$((PROBLEMAS + 1))
else
    echo "[OK]     Memória: ${USO_MEMORIA}% usada"
fi

# ---- 3. Serviços ----
# systemctl is-active --quiet -> Não mostra nada, só responde se está ativo ou não
for SERVICO in $SERVICOS; do
    if systemctl is-active --quiet "$SERVICO"; then
        echo "[OK]     Serviço $SERVICO: Rodando"
    else
        echo "[ALERTA] Serviço $SERVICO: Parado"
        PROBLEMAS=$((PROBLEMAS + 1))
    fi
done

# ---- Resultado ----
echo
if [ "$PROBLEMAS" -eq 0 ]; then
    echo "Tudo certo! Nenhum problema encontrado."
else
    echo "Atenção: $PROBLEMAS problema(s) encontrado(s)."
fi
