from flask import Flask, jsonify, request
import os
import redis

app = Flask(__name__)

# Configuración de Redis mediante variables de entorno
redis_host = os.getenv('REDIS_HOST', 'redis')
redis_port = int(os.getenv('REDIS_PORT', 6379))
redis_password = os.getenv('REDIS_PASSWORD', 'mysecret')

# Inicialización de la conexión Redis
r = redis.Redis(host=redis_host, port=redis_port, password=redis_password, decode_responses=True)

@app.route('/', methods=['GET'])
def get_and_increment_count():
    # Incrementa el contador en Redis
    count = r.incr('visits')
    return jsonify(visits=count), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
