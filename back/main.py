from flask import Flask, request, jsonify
from flask_cors import CORS

from RSAKeyGenerator import RSAKeyGenerator
from bd import BaseDeDatos

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "http://localhost:8080"}})


@app.route('/guardar_usuario', methods=['POST'])
def guardar_usuario():
    name = request.json.get('name')

    rsa_generator = RSAKeyGenerator()
    rsa_generator.generate_keys()

    private_key_pem = rsa_generator.get_private_key_pem()
    public_key_pem = rsa_generator.get_public_key_pem()

    bd = BaseDeDatos()
    respuesta = bd.guardar_usuario(nombre=name, public_key=public_key_pem)
    if name :
        response = {
            "message": "Usuario guardado exitosamente",
            "name": name,
            "privateKey": private_key_pem,
            "respuesta": respuesta
        }
        return jsonify(response), 201
    else:
        return jsonify({"error": "Faltan parámetros"}), 400


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
