#!/bin/bash

# Verificar se um comando foi fornecido como argumento
if [ "$#" -ne 1 ]; then
  echo "Uso: $0 'comando_stress_ng'"
  exit 1
fi

STRESS_CMD="$1"

if [ -z "$STRESS_CMD" ]; then
  echo "Nenhum comando stress-ng fornecido. Apenas coletando métricas de uso de CPU e memória."
else
  echo "Executando: $STRESS_CMD"
  # Executar o comando stress-ng em segundo plano
  $STRESS_CMD &
  STRESS_PID=$!
fi

sleep 5

# Adicionar cabeçalho se o arquivo estiver vazio ou
# cria o arquivo se ele não existir
if [ ! -s top_output.csv ]; then
  echo "Timestamp,Command,CPU_Usage(%),Mem_Usage(%)" > top_output.csv
fi

get_global_metrics() {
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  
  # Captura do uso de CPU e memória
  metrics=$(top -b -n 1 | awk '
    /^%Cpu/ {cpu_usage=$2 + $4}
    /^MiB Mem/ {
      mem_total=$4;
      mem_used=$8;
    }
    END {
      mem_usage = (mem_total > 0) ? (mem_used * 100 / mem_total) : 0;
      print cpu_usage " " mem_usage
    }
  ')

  cpu_usage=$(echo $metrics | awk '{print $1}')
  mem_usage=$(echo $metrics | awk '{print $2}')

  # Adicionar linha ao CSV
  echo "$timestamp,$STRESS_CMD,$cpu_usage,$mem_usage" >> top_output.csv
}

# Coletar dados globais enquanto o stress-ng estiver em execução,
# ou até que uma duração seja atingida se nenhum comando for dado
while true; do
  get_global_metrics
  sleep 5

  # Se o stress-ng estiver rodando, verificar se terminou
  if [ ! -z "$STRESS_CMD" ]; then
    if ! ps -p $STRESS_PID > /dev/null; then
      break
    fi
  else
    # Se não houver comando stress-ng, coletar por 60 sec
    sleep 60
    break
  fi
done

if [ ! -z "$STRESS_CMD" ]; then
  wait $STRESS_PID
fi

# Entrada final para marcar o fim da execução do stress-ng ou do período de coleta
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp,${STRESS_CMD},Process Ended,,,,," >> top_output.csv

