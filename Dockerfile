FROM python:3.9-slim

WORKDIR /app

# Instala o CURL para o Healthcheck funcionar
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY main.py .

# Garante que as libs estao instaladas
RUN pip install fastapi uvicorn prometheus-client

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]