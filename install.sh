#!/bin/bash

# Obtener la ruta absoluta donde está guardado este script
DIR_BASE="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

# Cargar variables del .env
if [ -f "$DIR_BASE/.env" ]; then
    export $(cat "$DIR_BASE/.env" | grep -v '#' | xargs)
else
    echo "Error: No se encontró el archivo .env en $DIR_BASE"
    exit 1
fi

OUTPUT_DIR="$DIR_BASE/data/dnsmasq.d"
TEMP_DIR="/tmp/cache-domains"

echo "=== Descargando dominios de videojuegos actualizados ==="
rm -rf $TEMP_DIR
git clone --depth=1 https://github.com/uklans/cache-domains.git $TEMP_DIR

echo "=== Generando configuraciones dnsmasq para Pi-hole ==="
cd $TEMP_DIR/scripts

# Configurar el compilador con tu IP de LanCache del .env
echo '{"ips": {"generic": "'$LANCACHE_IP'"}, "cache_domains": {"default": "generic"}}' > config.json

# Ejecutar el script oficial de la comunidad para compilar los archivos .conf
bash create-dnsmasq.sh

echo "=== Inyectando archivos en la infraestructura ==="
# Eliminar configuraciones viejas de juegos para evitar duplicados residuales
rm -f $OUTPUT_DIR/10-lancache-*.conf

# Copiar las nuevas listas generadas a la carpeta de volumen de Pi-hole
cp output/dnsmasq/*.conf $OUTPUT_DIR/

echo "=== Reiniciando DNS de Pi-hole ==="
docker exec pihole pihole restartdns

# Limpieza de archivos temporales
rm -rf $TEMP_DIR
echo "=== ¡Proceso completado con éxito! ==="
