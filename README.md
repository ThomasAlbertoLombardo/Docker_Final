# Contador Flask/Redis

## Descripción

Esta es una aplicación web sencilla construida con Flask que implementa un contador de visitas utilizando Redis como base de datos. La aplicación permite visualizar el número de visitas a través de un endpoint HTTP, y el contador de visitas se incrementa automáticamente cada vez que se accede a la ruta principal.

## Funcionamiento de la Aplicación

- **`GET /`**: Incrementa el contador de visitas en 1 y retorna el nuevo valor en formato JSON.
  
Cada vez que se accede a la ruta principal (`/`), el contador de visitas en Redis aumenta y se muestra el valor actualizado.

## Requisitos

- Docker
- Docker Compose

## Instrucciones para Ejecutar la Aplicación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/ThomasAlbertoLombardo/Docker_Final.git
   ```

2. Accede al directorio del proyecto: 
   ```bash
   cd Docker_Final  
   ```

3. Construye y ejecuta los contenedores con Docker Compose:
   ```bash
   docker-compose up --build  
   ```

4. Accede a la aplicación en tu navegador web o utiliza curl:
   
   - URL: http://localhost:5000
5. Para verificar el número de visitas:

   - Abre tu navegador y visita http://localhost:5000.
   - Cada vez que accedas a esta URL, el contador de visitas aumentará en 1 y se mostrará el número total de visitas en formato JSON.

6. Para detener la aplicación y eliminar los contenedores:
   ```bash
   docker-compose down  
   ```
## Notas

- El servicio Redis se expone en el puerto `6379`, y la aplicación Flask se ejecuta en el puerto `5000`.
- Los datos de Redis se almacenan de forma persistente en un volumen de Docker llamado `redis_data`.
