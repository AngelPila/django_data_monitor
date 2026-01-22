#!/bin/bash
set -e

# Ejecutar migraciones
python manage.py migrate

# Crear superuser si no existe
python manage.py shell << END
from django.contrib.auth.models import User
import os

if not User.objects.filter(username=os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin')).exists():
    User.objects.create_superuser(
        username=os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin'),
        email=os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com'),
        password=os.environ.get('DJANGO_SUPERUSER_PASSWORD', 'admin')
    )
    print("Superuser created successfully")
else:
    print("Superuser already exists")
END

# Recolectar archivos estáticos
python manage.py collectstatic --noinput

# Iniciar el servidor
exec "$@"
