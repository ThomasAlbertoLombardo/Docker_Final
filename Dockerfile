# Etapa 1: Construcción
FROM python:3.9-slim AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar archivos necesarios
COPY requirements.txt .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Etapa 2: Imagen final
FROM python:3.9-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar dependencias desde la etapa de construcción
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copiar el código de la aplicación
COPY app.py .

# Exponer el puerto de la aplicación
EXPOSE 5000

# Comando de inicio de la aplicación
CMD ["python", "app.py"]
