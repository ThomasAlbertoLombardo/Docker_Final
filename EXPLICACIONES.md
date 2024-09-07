# Explicación del Docker Compose

Este archivo `docker-compose.yml` se encarga de definir y configurar los servicios que se ejecutarán en contenedores Docker. En este caso, se definen dos servicios principales: uno para la aplicación web basada en Flask y otro para el servidor Redis. A continuación se detalla cada parte del archivo.

## Servicios

### 1. Servicio `web`

Este es el servicio que ejecuta la aplicación Flask.

```yaml
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
      - REDIS_PASSWORD=${REDIS_PASSWORD}
    depends_on:
      - redis
```

### Explicación:

#### `build: .`
Indica que Docker debe construir la imagen para este servicio a partir del `Dockerfile` que se encuentra en el directorio actual (`.`).

#### `ports: `

**"5000:5000"**: Expone el puerto `5000` del contenedor y lo asigna al puerto `5000` de la máquina host, lo que permite acceder a la aplicación Flask a través de `http://localhost:5000`.

#### `environment:`

- **`REDIS_HOST=${REDIS_HOST}`**: Utiliza la variable de entorno `REDIS_HOST` que proviene del archivo `.env`. Define la dirección del servidor Redis (por defecto es `redis`, que es el nombre del servicio Redis definido en el archivo).
- **`REDIS_PORT=${REDIS_PORT}`**: Define el puerto en el que Redis escucha (por defecto `6379`, que es el puerto estándar de Redis).
- **`REDIS_PASSWORD=${REDIS_PASSWORD}`**: Define la contraseña que se utiliza para conectarse al servidor Redis.

#### `depends_on:`

**redis**: Este parámetro indica que el servicio `web` depende del servicio `redis`. Significa que Docker primero iniciará el servicio Redis antes de intentar iniciar el servicio Flask.

### 2. Servicio `redis`

Este es el servicio que ejecuta el servidor Redis.

```yaml
  redis:
    image: redis:6.2-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
```
### Explicación:

#### `image: redis:6.2-alpine`

Utiliza la imagen oficial de Redis, en su versión `6.2` basada en Alpine Linux, que es una versión ligera y eficiente.

#### `command: redis-server --requirepass ${REDIS_PASSWORD}`

Ejecuta Redis con la opción de requerir una contraseña para acceder a él. La contraseña se toma de la variable de entorno `REDIS_PASSWORD` definida en el archivo `.env`.

#### `volumes:`

**redis_data:/data**: Asigna un volumen llamado `redis_data` que está montado en el directorio `/data` del contenedor. Esto significa que los datos de Redis se almacenarán de forma persistente en el host, y no se perderán cuando se detenga o elimine el contenedor.

#### `ports:`

**"6379:6379"**: Expone el puerto `6379` del contenedor y lo asigna al puerto `6379` de la máquina host, lo que permite que la aplicación Flask se comunique con Redis.

### 3. Volúmenes

```yaml
volumes:
  redis_data:
```

### Explicación:

#### `redis_data:`

Define un volumen llamado `redis_data` que será utilizado por el servicio Redis. Los datos almacenados por Redis en el directorio `/data` se guardarán en este volumen, lo que garantiza que los datos persistan incluso si el contenedor se detiene o se elimina.

## Resumen

- El archivo `docker-compose.yml` define dos servicios: `web` (Flask) y `redis` (Redis).
- El servicio `web` depende del servicio `redis`, y utiliza Redis para almacenar el contador de visitas.
- Redis almacena sus datos en un volumen persistente llamado `redis_data`.
- Los puertos `5000` (para Flask) y `6379` (para Redis) están expuestos, permitiendo el acceso desde el host.
- Las variables de entorno para Redis, como el host, el puerto y la contraseña, están configuradas en el archivo `.env`.


# Explicación del Dockerfile

Este archivo `Dockerfile` define cómo se construye la imagen de Docker para la aplicación Flask. A continuación, se detallan los pasos de construcción y ejecución que sigue Docker para crear un contenedor funcional con la aplicación.

## Etapas del Dockerfile

Este `Dockerfile` utiliza una estrategia de construcción en **dos etapas** para crear una imagen más ligera. La primera etapa instala las dependencias y la segunda ejecuta la aplicación.

---

### Etapa 1: Construcción

```dockerfile
FROM python:3.9-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
```
### Explicación:

#### `FROM python:3.9-slim AS build`
Define la imagen base para la etapa de construcción. Se utiliza una versión ligera de Python 3.9 (`python:3.9-slim`). Esta imagen incluye solo lo necesario para ejecutar aplicaciones Python y tiene un tamaño reducido.

#### `WORKDIR /app`
Establece el directorio de trabajo dentro del contenedor en `/app`. Todas las operaciones posteriores (como copiar archivos o ejecutar comandos) se realizarán en este directorio.

#### `COPY requirements.txt .`
Copia el archivo `requirements.txt` desde tu máquina local al contenedor dentro del directorio `/app`. Este archivo contiene todas las dependencias que la aplicación necesita para funcionar.

#### `RUN pip install --no-cache-dir -r requirements.txt`
Este comando instala las dependencias listadas en el archivo `requirements.txt` utilizando `pip`. La opción `--no-cache-dir` asegura que no se almacenen archivos temporales durante la instalación, reduciendo el tamaño final de la imagen.


### Etapa 2: Imagen Final

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```
### Explicación:

#### `FROM python:3.9-slim`
Define la imagen base para la etapa final de la imagen. Se vuelve a utilizar `python:3.9-slim`, lo que asegura que el contenedor solo tenga lo necesario para ejecutar la aplicación, sin las herramientas de construcción que se usaron en la primera etapa.

#### `WORKDIR /app`
Al igual que en la primera etapa, se establece el directorio de trabajo en `/app`. Este es el lugar donde se copiarán los archivos de la aplicación.

#### `COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages`
Copia las dependencias que se instalaron durante la etapa de construcción desde el directorio `/usr/local/lib/python3.9/site-packages` al mismo directorio en la imagen final. Esta técnica evita que la imagen final tenga archivos y herramientas innecesarias, resultando en una imagen más ligera.

#### `COPY app.py .`
Copia el archivo `app.py` (el código de la aplicación Flask) desde el host al directorio `/app` dentro del contenedor.

#### `EXPOSE 5000`
Expone el puerto `5000` dentro del contenedor. Este es el puerto en el que la aplicación Flask estará escuchando, permitiendo que la aplicación sea accesible externamente a través del puerto 5000 de la máquina host.

#### `CMD ["python", "app.py"]`
Define el comando que se ejecutará por defecto cuando el contenedor se inicie. En este caso, se ejecutará `python app.py`, lo que iniciará la aplicación Flask.

---

### Resumen:

- El `Dockerfile` está dividido en dos etapas: una de construcción para instalar dependencias y una imagen final que contiene únicamente lo necesario para ejecutar la aplicación.
- La etapa de construcción utiliza una imagen de Python 3.9 y realiza la instalación de las dependencias especificadas en `requirements.txt`.
- La etapa final copia solo las dependencias necesarias y el código de la aplicación, dejando de lado los archivos de construcción para reducir el tamaño de la imagen.
- La aplicación se ejecuta en el puerto `5000` y se inicia con el comando `python app.py`.
- Este enfoque multi-etapas en Docker permite crear imágenes más pequeñas y eficientes, mejorando el rendimiento y reduciendo el espacio de almacenamiento necesario.
