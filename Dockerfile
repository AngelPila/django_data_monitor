FROM python:3.12-slim

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    default-libmysqlclient-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements
COPY requirements.txt .

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar proyecto
COPY . .

# Copiar script de entrada
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

# Exponer puerto
EXPOSE 8000

# Usar el script de entrada
ENTRYPOINT ["/app/entrypoint.sh"]

# Comando por defecto
CMD ["gunicorn", "backend_analytics_server.wsgi:application", "--bind", "0.0.0.0:8000"]
