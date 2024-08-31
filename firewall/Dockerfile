FROM alpine:latest

# Instalar iptables
RUN apk --no-cache add iptables

# Copiar el script de configuración
COPY init-iptables.sh /init-iptables.sh

# Dar permisos de ejecución al script
RUN chmod +x /init-iptables.sh

# Ejecutar el script al iniciar el contenedor
CMD ["sh", "/init-iptables.sh"]
