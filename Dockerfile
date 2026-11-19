FROM python:3.12-slim

WORKDIR /app

# pytest lance le binaire sans ajouter le répertoire courant au sys.path :
# PYTHONPATH garantit que "from app import app" fonctionne dans les tests.
ENV PYTHONPATH=/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY tests ./tests

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
