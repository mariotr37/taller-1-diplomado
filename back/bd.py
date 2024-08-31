import mysql.connector
import os
from dotenv import load_dotenv

class BaseDeDatos:
    def __init__(self):
        # Cargar variables de entorno desde el archivo .env
        load_dotenv()

        # Leer variables de entorno
        self.host = os.getenv("DB_HOST")
        self.user = os.getenv("DB_USER")
        self.password = os.getenv("DB_PASSWORD")
        self.database = os.getenv("DB_NAME")

        self.conn = None

    def conectar(self):
        """Establece la conexión a la base de datos."""
        if self.conn is None:
            try:
                self.conn = mysql.connector.connect(
                    host=self.host,
                    user=self.user,
                    password=self.password,
                    database=self.database,
                    charset='utf8mb4',
                    collation='utf8mb4_general_ci'
                )
                print("Conexión a la base de datos establecida exitosamente.")
            except mysql.connector.Error as e:
                print(f"Error conectando a la base de datos: {e}")
                raise

    def obtener_conexion(self):
        """Devuelve la conexión a la base de datos."""
        if self.conn is None:
            self.conectar()
        return self.conn

    def cerrar_conexion(self):
        """Cierra la conexión a la base de datos."""
        if self.conn is not None:
            self.conn.close()
            self.conn = None
            print("Conexión a la base de datos cerrada.")

    def guardar_usuario(self, nombre, public_key):
        """Guarda un usuario en la tabla 'usuario' con su nombre y public key."""
        try:
            conn = self.obtener_conexion()
            cursor = conn.cursor()

            # Inserta el usuario en la tabla 'usuario'
            sql = "INSERT INTO Usuarios (Name, PublicKey) VALUES (%s, %s)"
            cursor.execute(sql, (nombre, public_key))

            # Confirma la transacción
            conn.commit()
            cursor.close()
            return "Usuario guardado exitosamente."

        except mysql.connector.Error as e:
            return f"Error guardando el usuario: {e}"
#
#
# # Ejemplo de uso
# if __name__ == "__main__":
#     bd = BaseDeDatos()
#     bd.guardar_usuario("juan", "key")
#     bd.cerrar_conexion()
#     # Realizar operaciones con la base de datos...
