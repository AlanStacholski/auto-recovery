# 🛡️ Resilient System: Chaos & Auto-Recovery

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)

> *"Robust systems are not those that never fall, but those that get back up on their own before the customer notices."*

This project is a practical implementation of **Chaos Engineering** and **Observability**. The goal is to prove the effectiveness of *Self-Healing* architectures in containerized environments, monitoring metrics in real-time while deliberately injecting critical failures.

---

## ⚡ Why is this project relevant?

Most portfolio projects focus only on application development ("Happy Path"). This project focuses on **Operations and Resilience**, simulating the real world where failures are inevitable.

It demonstrates critical competencies:
1.  **SRE (Site Reliability Engineering) Mindset:** Accept that failure will occur and design the system to handle it automatically.
2.  **DevOps Culture:** It's not enough to "code"; you must ensure the system sustains itself in production without manual intervention at 3 AM.
3.  **Real Observability:** Monitoring isn't just checking if the server is on, but understanding recovery time (MTTR) and endpoint health via data.
4.  **Complex Problem-Solving:** Dealing with native orchestrator behaviors, such as *CrashLoops* and *Exponential Backoff*.

---

## 🧠 The Technical Challenge

The premise seems simple: kill a container and watch it come back. However, in practice, we face the **Exponential Backoff** behavior of Docker.

### The Problem
If a script kills the container repeatedly without pauses, Docker enters protection mode, delaying restart (10s, 20s, 40s...). This generates false negatives in tests and instability in metrics.

### The Solution ("Smart Chaos")
I developed a failure injection script (`smart_chaos.ps1`) that acts as a **chaos-aware orchestrator**:
1.  **Monitors State:** It checks the Docker Daemon before striking.
2.  **Respects the Cycle:** If the container is `restarting` or `exited`, the script waits.
3.  **Surgical Attack:** The `kill` command is only fired when the application is provably healthy (`running`).

---

## 🚀 How to Run

### Prerequisites

* Docker and Docker Compose installed.

### 1. Initialize the Infrastructure

Bring up the application and monitoring stack:

```bash
docker-compose up -d --build

```

### 2. Configure Observability

1. Access Grafana at `http://localhost:3000` (admin/admin).
2. Add the Data Source: `http://prometheus:9090`.
3. Import the Dashboard or create a panel with the query: `up{job="chaos_app"}`.

### 3. Start the Chaos

Execute the intelligent script (Windows/PowerShell) that brings down the application randomly:

```powershell
.\smart_chaos.ps1

```

*The terminal will show monitoring logs, the attack, and wait for recovery.*

---

## 📊 Key Metrics

During chaos engineering test execution, the following metrics were observed on the Dashboard:

| Metric | Description | Result |
| --- | --- | --- |
| **Uptime** | Service availability | 99.9% (Immediate recovery) |
| **MTTR** | Mean Time To Recovery | ~3 to 5 seconds |
| **Crash Loops** | Continuous failure cycles | Mitigated by script logic |

---

## 💡 Learnings

1. **Observability is not optional:** Without Prometheus, we wouldn't know the difference between a "network hiccup" and a "dead process".
2. **Graceful Shutdown vs Hard Kill:** Using `docker kill` simulates the worst case (power loss/kernel panic), proving that `restart: always` is an effective last line of defense.
3. **Docker Healthchecks:** Recovery is only considered "complete" when the `/health` endpoint responds with 200 OK, not just when the container starts.

---

## 📂 Project Structure

```text
.
├── main.py            # Victim API (FastAPI)
├── Dockerfile         # Container Definition (with curl for healthcheck)
├── docker-compose.yml # Orchestration and Auto-Recovery
├── prometheus.yml     # Scrape Configuration
├── smart_chaos.ps1    # The Intelligent Chaos Agent
└── README.md          # Documentation

```

---

**Author:** [Alan J Stacholski Júnior]
*Project developed to demonstrate SRE and DevOps competencies.*
