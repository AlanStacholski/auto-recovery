from fastapi import FastAPI, Response
from prometheus_client import generate_latest, Counter
import os

app = FastAPI()
REQUESTS = Counter('http_requests_total', 'Total de requisicoes')

@app.get("/")
def read_root():
    REQUESTS.inc()
    return {"status": "alive", "hostname": os.uname()[1]}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain")