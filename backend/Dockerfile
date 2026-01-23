# ---------- Build Stage ----------
FROM python:3.11-slim AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY . .

# ---------- Runtime Stage ----------
FROM python:3.11-slim

RUN useradd -m appuser
WORKDIR /app

COPY --from=builder /root/.local /root/.local
COPY --from=builder /app /app

ENV PATH=/root/.local/bin:$PATH
USER appuser

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
