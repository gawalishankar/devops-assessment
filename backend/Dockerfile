# ---------- Build Stage ----------
FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

COPY . .

# ---------- Runtime Stage ----------
FROM python:3.11-slim

RUN useradd -m appuser

WORKDIR /app

# Copy dependencies from build stage
COPY --from=builder /install /usr/local
COPY --from=builder /app /app

# Fix permissions so SQLite can write
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
