#!/bin/bash

# --- CONFIGURACIÓN DE LOS ENLACES DE GOOGLE DRIVE ---
ID_CONFIG="1KZw73n2S4cDyvUNAkzTuV-yEd4cENS1D"
ID_UFW="12VhpxhTgp7Hjnpg3KFnm2KY11arNX2LA"

FILE_CONFIG="backup_homeserver_config.tar.gz"
FILE_UFW="backup_homeserver_ufw.tar.gz"

mostrar_menu() {
    clear
    echo "=========================================================="
    echo "   SCRIPT DE MIGRACIÓN PARA ARCH SERVER (CON GOOGLE DRIVE) "
    echo "=========================================================="
    echo "1) Crear Respaldo (Ejecutar en el servidor ACTUAL)"
    echo "2) Restaurar Servidor Nuevo (Descarga automática desde Drive)"
    echo "3) Salir"
    echo "=========================================================="
    read -p "Selecciona una opción [1-3]: " opcion
}

crear_respaldo() {
    echo ""
    if [ ! -f "docker-compose.yml" ]; then
        echo "ERROR: No se encuentra el archivo 'docker-compose.yml' en esta carpeta."
        echo "Asegúrate de ejecutar el script en la raíz de tus contenedores."
        exit 1
    fi

    echo "Creando copia de seguridad de las configuraciones (.data y compose)..."
    sudo tar -cpzvf "$FILE_CONFIG" --numeric-owner ./data docker-compose.yml

    echo "Creando copia de seguridad del cortafuegos (UFW)..."
    sudo tar -cpzvf "$FILE_UFW" --numeric-owner /etc/ufw/user.rules /etc/ufw/user6.rules /etc/default/ufw

    echo ""
    echo "=========================================================="
    echo " ¡RESPALDO CREADO CON ÉXITO! "
    echo "=========================================================="
    echo "Se han generado los archivos locales:"
    echo "  - $FILE_CONFIG"
    echo "  - $FILE_UFW"
    echo "Recuerda subirlos a tu Google Drive si has hecho cambios nuevos."
    echo "=========================================================="
}

restaurar_servidor() {
    echo ""
    # Asegurar que el usuario corre el script como root/sudo
    if [ "$EUID" -ne 0 ]; then
        echo "ERROR: Debes ejecutar la restauración usando 'sudo ./migracion_homeserver.sh'"
        exit 1
    fi

    echo "🌐 Descargando archivos de configuración desde Google Drive..."
    # Comandos curl optimizados para saltar el aviso de archivos grandes de Drive si fuera necesario
    curl -L "https://google.com" -o "$FILE_CONFIG"
    curl -L "https://google.com" -o "$FILE_UFW"

    if [ ! -f "$FILE_CONFIG" ] || [ ! -f "$FILE_UFW" ]; then
        echo "ERROR: La descarga desde Google Drive ha fallado. Verifica tu conexión a internet."
        exit 1
    fi

    echo "Instalar paquetes necesarios en Arch Linux (Docker + UFW)..."
    pacman -Sy --needed docker docker-compose ufw --noconfirm

    echo "Creando estructura de carpetas multimedia limpias..."
    mkdir -p /home/data/media/movies /home/data/media/tv /home/data/torrents/completados
    
    echo "Ajustando permisos numéricos (1000:1000) para evitar bloqueos..."
    chown -R 1000:1000 /home/data
    chmod -R 775 /home/data

    echo "Desempaquetando configuraciones de los contenedores..."
    tar -xpxzvf "$FILE_CONFIG" -C .

    echo "Aplicando reglas y activando el cortafuegos UFW..."
    tar -xpxzvf "$FILE_UFW" -C /
    ufw reload
    systemctl enable --now ufw

    echo "Habilitando e iniciando el servicio de Docker..."
    systemctl enable --now docker

    echo "Levantando todo el ecosistema de contenedores (*Arrs + Jellyfin)..."
    docker-compose up -d

    echo ""
    echo "=========================================================="
    echo " ¡MIGRACIÓN COMPLETADA CON ÉXITO! "
    echo "=========================================================="
    echo "Todo tu servidor ha sido restaurado con sus permisos intactos."
    echo "Verifica los servicios entrando desde el navegador de otro PC."
    echo "=========================================================="
}

# --- FLUJO PRINCIPAL ---
mostrar_menu

case $opcion in
    1) crear_respaldo ;;
    2) restaurar_servidor ;;
    3) echo "Saliendo del script..."; exit 0 ;;
    *) echo "Opción no válida."; exit 1 ;;
esac
