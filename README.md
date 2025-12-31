# 🛡️ Resilient System: Chaos & Auto-Recovery

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)

> *"Sistemas robustos não são aqueles que nunca caem, mas aqueles que se levantam sozinhos antes que o cliente perceba."*

Este projeto é uma implementação prática de **Engenharia de Caos (Chaos Engineering)** e **Observabilidade**. O objetivo é provar a eficácia de arquiteturas *Self-Healing* (auto-recuperáveis) em ambientes containerizados, monitorando métricas em tempo real enquanto falhas críticas são injetadas propositalmente.

---

## ⚡ Por que este projeto é relevante?

A maioria dos projetos de portfólio foca apenas no desenvolvimento da aplicação ("Caminho Feliz"). Este projeto foca na **Operação e Resiliência**, simulando o mundo real onde falhas são inevitáveis.

Ele demonstra competências críticas:
1.  **Mentalidade SRE (Site Reliability Engineering):** Aceitar que a falha vai ocorrer e projetar o sistema para lidar com ela automaticamente.
2.  **Cultura DevOps:** Não basta "codar", é preciso garantir que o sistema se sustente em produção sem intervenção manual às 3 da manhã.
3.  **Observabilidade Real:** Monitoramento não é apenas ver se o servidor está ligado, mas entender o tempo de recuperação (MTTR) e a saúde dos endpoints via dados.
4.  **Resolução de Problemas Complexos:** Lidar com comportamentos nativos do orquestrador, como *CrashLoops* e *Exponential Backoff*.

---

## 🧠 O Desafio Técnico

A premissa parece simples: matar um container e vê-lo voltar. Porém, na prática, enfrentamos o comportamento de **Exponential Backoff** do Docker.

### O Problema
Se um script mata o container repetidamente sem pausas, o Docker entra em modo de proteção, atrasando o restart (10s, 20s, 40s...). Isso gera falsos negativos nos testes e instabilidade na métrica.

### A Solução ("Smart Chaos")
Desenvolvi um script de injeção de falhas (`smart_chaos.ps1`) que atua como um **orquestrador de caos consciente**:
1.  **Monitora o Estado:** Ele consulta o Docker Daemon antes de atirar.
2.  **Respeita o Ciclo:** Se o container está `restarting` ou `exited`, o script aguarda.
3.  **Ataque Cirúrgico:** O comando `kill` só é disparado quando a aplicação está comprovadamente saudável (`running`).

---

## 🚀 Como Executar

### Pré-requisitos

* Docker e Docker Compose instalados.

### 1. Inicializar a Infraestrutura

Suba a aplicação e a stack de monitoramento:

```bash
docker-compose up -d --build

```

### 2. Configurar Observabilidade

1. Acesse o Grafana em `http://localhost:3000` (admin/admin).
2. Adicione o Data Source: `http://prometheus:9090`.
3. Importe o Dashboard ou crie um painel com a query: `up{job="chaos_app"}`.

### 3. Iniciar o Caos

Execute o script inteligente (Windows/PowerShell) que derruba a aplicação aleatoriamente:

```powershell
.\smart_chaos.ps1

```

*O terminal mostrará os logs de monitoramento, tiro e espera pela recuperação.*

---

## 📊 Métricas Chave

Durante a execução dos testes de caos, as seguintes métricas foram observadas no Dashboard:

| Métrica | Descrição | Resultado |
| --- | --- | --- |
| **Uptime** | Disponibilidade do serviço | 99.9% (Recuperação imediata) |
| **MTTR** | Tempo Médio de Recuperação | ~3 a 5 segundos |
| **Crash Loops** | Ciclos de falha contínua | Mitigados pela lógica do script |

---

## 💡 Aprendizados

1. **Observabilidade não é opcional:** Sem o Prometheus, não saberíamos a diferença entre uma "oscilação de rede" e um "processo morto".
2. **Graceful Shutdown vs Hard Kill:** O uso do `docker kill` simula o pior cenário (falta de energia/kernel panic), provando que o `restart: always` é a última linha de defesa eficaz.
3. **Docker Healthchecks:** A recuperação só é considerada "completa" quando o endpoint `/health` responde 200 OK, não apenas quando o container liga.

---

## 📂 Estrutura do Projeto

```text
.
├── main.py            # API Vítima (FastAPI)
├── Dockerfile         # Definição do Container (com curl p/ healthcheck)
├── docker-compose.yml # Orquestração e Auto-Recovery
├── prometheus.yml     # Configuração de Scrape
├── smart_chaos.ps1    # O Agente do Caos Inteligente
└── README.md          # Documentação

```

---

**Autor:** [Alan J Stacholski Júnior]
*Projeto desenvolvido para demonstração de competências em SRE e DevOps.*

```
