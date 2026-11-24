#!/bin/bash
# Health-check.sh - Verifica a saúde do sistema
# Uso: ./health-check.sh

# ---- Configuração ----
LIMITE=1	# Alerta quando o uso passar de 80%

echo "===== Health Check: $(hostname) ====="
echo "Data: $(date '+%d/%m/%Y %H:%M')"
echo

# ---- 1. Disco ----
# dh -h /	-> Mostra o uso da partição principal
# awk 'NR==2'	-> Pega só a 2ª linha (a 1ª é o cabeçalho)
# tr -d '%'	-> Tira o símbolo de %
USO_DISCO=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$USO_DISCO" -gt "$LIMITE" ]; then
	echo "[ALERTA]	Disco: ${USO_DISCO}% usado"
else
	echo "[OK]	Disco: ${USO_DISCO}% usado"
fi
