# Flask Redis Counter

## Descripción

Esta es una aplicación web sencilla construida con Flask que implementa un contador de visitas utilizando Redis como base de datos. La aplicación permite incrementar y visualizar el número de visitas a través de endpoints HTTP.

## Funcionamiento de la Aplicación

- **`GET /`**: Retorna el número actual de visitas.
- **`POST /`**: Incrementa el contador de visitas en 1 y retorna el nuevo valor.

## Requisitos

- Docker
- Docker Compose

## Instrucciones para Ejecutar la Aplicación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu-usuario/flask-redis-counter.git
   ```

/////////////// POR COMPLETAR ////////////////////
docker build -t practica_final-web .

base de datos.:
docker run -d --name practica_final-db -e POSTGRES_DB=mi_base_de_datos -e POSTGRES_USER=mi_usuario -e POSTGRES_PASSWORD=mi_contraseña -p 5432:5432 postgres:13

app:
docker run -d --name practica_final-web -p 5000:5000 --link practica_final-db:db -e DATABASE_URL=postgresql://mi_usuario:mi_contraseña@db:5432/mi_base_de_datos practica_final-web

logs:
docker logs practica_final-web
docker logs practica_final-db

detener y eliminar:
docker stop practica_final-web practica_final-db
docker rm practica_final-web practica_final-db