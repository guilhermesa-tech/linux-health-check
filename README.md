# linux-health-check

Script Bash para verificar a saúde de um sistema Linux.

## O que verifica

- **Uso de disco**: uso da partição principal (`/`)
- **Uso de memória**: uso da memória RAM
- **Serviços**: se estão rodando (padrão: `cron` e `NetworkManager`)

## Como usar

```bash
git clone https://github.com/guilhermesa-tech/linux-health-check.git
cd linux-health-check
chmod +x health-check.sh
./health-check.sh
```

## Exemplo de saída

```
===== Health Check: pc =====
Data: 24/11/2026 16:13

[OK]     Disco: 8% usado
[OK]     Memória: 46% usada
[OK]     Serviço cron: Rodando
[OK]     Serviço NetworkManager: Rodando

Tudo certo! Nenhum problema encontrado.
```

Quando algo passa do limite:

```
[ALERTA] Disco: 92% usado
[OK]     Memória: 46% usada
[OK]     Serviço cron: Rodando
[ALERTA] Serviço nginx: Parado

Atenção: 2 problema(s) encontrado(s).
```

## Configuração

No começo do script:

```bash
LIMITE=80                         # alerta quando o uso passar de 80%
SERVICOS="cron NetworkManager"    # serviços que devem estar rodando
```

Em um servidor, troque os serviços pelos que ele usa, como `ssh`, `nginx` ou `docker`.

## Como funciona

- **Disco**: lê o uso da partição `/` com `df` e compara com o limite.
- **Memória**: calcula a porcentagem de RAM usada a partir do `free`.
- **Serviços**: consulta cada serviço com `systemctl is-active`.
- As linhas da saída dos comandos são lidas por posição (`NR==2`), e não por texto, para o script funcionar em sistemas em qualquer idioma.

## Próximas melhorias

- [ ] Verificar o uso de CPU
- [ ] Salvar o resultado em um arquivo de log
- [ ] Rodar automaticamente com o cron
