# Atividade: Sobrecarregando Interfaces do Kernel com Stress-ng e Análise com Top
## Objetivo
    O objetivo desta atividade é utilizar a ferramenta stress-ng para gerar carga de trabalho e sobrecarregar as interfaces do kernel do sistema operacional. Em seguida, utilizaremos o comando top para monitorar e capturar métricas de desempenho, como o uso da CPU e da memória, durante o período de estresse. Por fim, as métricas são colocadas em um arquivo .csv e podem ser usadas para futuras avaliações.

## Como utilizar
### 1. Baixe o script get_global_metrics.sh
### 2. Instale o stress-ng na sua máquina
`sudo apt-get install stress-ng`
### 3. Permita a execução do script
Para a primeira vez executando o arquivo, habilite sua permissão.
`chmod +x get_global_metrics.sh`
### 4. Execute o script
Execute o script fornecendo como argumento um comando do stress-ng.
`./stress_ng_monitor.sh "comando_stress-ng"`
Caso queira apenas coletar métricas sem estressar, para gerar comparação, deixe o espaço de comando vazio. As métricas serão coletadas por 60 segundos.
`./stress_ng_monitor.sh ""`
### 5. Análise de métricas
    As métricas coletadas serão colocadas em um arquivo chamado top_output.csv. Caso o script esteja sendo rodado pela primeira vez e o arquivo não exista, ele será criado juntamente com seu cabeçalho. Caso o arquivo já exista, as novas métricas serão acrescentadas.

Esse repositório contém, além do script, um arquivo top_output.csv que foi gerado com alguns comandos, para exemplificar um possível output.
