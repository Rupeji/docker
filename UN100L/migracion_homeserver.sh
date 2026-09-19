#!/bin/bash
# ==============================================================================
# SCRIPT DE RESPALDO Y DESPLIEGUE AUTOMÁTICO (HOMESERVER ARCH)
# ==============================================================================
# Este script automatiza la exportación de configuraciones (Docker + UFW)
# preservando estrictamente los permisos (UID/GID 1000) y recrea la estructura
# limpia en un nuevo PC para empezar a descargar desde cero sin errores.

BACKUP_NAME_DOCKER="backup_homeserver_config.tar.gz"
BACKUP_NAME_UFW="backup_homeserver_ufw.tar.gz"

mostrar_menu() {
    clear
    echo "========================================================"
    echo "   GESTOR DE COPIAS DE SEGURIDAD Y MIGRACIÓN LIMPIA   "
    echo "========================================================"
    echo "1) CREAR RESPALDO (En el servidor actual)"
    echo "2) RESTAURAR E INSTALAR TODO (En el PC nuevo)"
    echo "3) Salir"
    echo "========================================================"
    read -p "Selecciona una opción [1-3]: " opcion
    case $opcion in
        1) crear_respaldo ;;
        2) restaurar_servidor ;;
        3) exit 0 ;;
        *) mostrar_menu ;;
    esac
}

crear_respaldo() {
    echo ""
    echo "[*] Generando copia de seguridad de las configuraciones..."
    
    # Comprobar que existe docker-compose y la carpeta data
    if [ ! -f "docker-compose.yml" ] || [ ! -d "./data" ]; then
        echo "[!] Error: No se encuentra 'docker-compose.yml' o la carpeta './data' en este directorio."
        exit 1
    fi
    
    # Empaquetar configuraciones preservando permisos numéricos (--numeric-owner)
    # y los permisos originales de Linux (-p)
    sudo tar --numeric-owner -cpzvf "$BACKUP_NAME_DOCKER" ./data docker-compose.yml
    
    echo "[*] Generando copia de seguridad del cortafuegos (UFW)..."
    if [ -d "/etc/ufw" ]; then
        sudo tar --numeric-owner -cpzvf "$BACKUP_NAME_UFW" /etc/ufw/user.rules /etc/ufw/user6.rules /etc/default/ufw
    else
        echo "[!] Advertencia: UFW no está instalado o no se encuentra en /etc/ufw."
    fi
    
    echo ""
    echo "========================================================"
    echo "¡RESPALDO COMPLETADO CON ÉXITO!"
    echo "========================================================"
    echo "Lleva estos dos archivos a tu nuevo PC en un pendrive:"
    echo " 1) $BACKUP_NAME_DOCKER"
    echo " 2) $BACKUP_NAME_UFW"
    echo "========================================================"
    exit 0
}

restaurar_servidor() {
    echo ""
    echo "========================================================"
    echo "          INICIANDO RESTAURACIÓN EN EL NUEVO PC         "
    echo "========================================================"
    
    # 1. Verificar que los archivos de respaldo están presentes
    if [ ! -f "$BACKUP_NAME_DOCKER" ] || [ ! -f "$BACKUP_NAME_UFW" ]; then
        echo "[!] Error: No se encuentran los archivos de respaldo en este directorio."
        echo "Asegúrate de haber copiado '$BACKUP_NAME_DOCKER' y '$BACKUP_NAME_UFW' aquí."
        exit 1
    fi

    # 2. Instalar dependencias necesarias en Arch Linux si no existen
    echo "[*] Instalando dependencias del sistema (Docker, Docker Compose, UFW)..."
    sudo pacman -S --needed docker docker-compose ufw --noconfirm
    
    # Habilitar e iniciar el servicio de Docker
    sudo systemctl enable --now docker
    
    # 3. Recrear la estructura de carpetas limpia (sin películas ni series)
    echo "[*] Creando estructura de directorios multimedia limpia..."
    sudo mkdir -p /home/data/media/movies
    sudo mkdir -p /home/data/media/tv
    sudo mkdir -p /home/data/torrents/completados
    
    # Forzar los permisos ID 1000:1000 (usuario 'inhumano' y grupo por defecto)
    echo "[*] Ajustando permisos de propiedad (1000:1000) y lectura/escritura (775)..."
    sudo chown -R 1000:1000 /home/data
    sudo chmod -R 775 /home/data

    # 4. Restaurar el ecosistema de aplicaciones Arr y configuraciones
    echo "[*] Desempaquetando configuraciones de Docker manteniendo permisos originales..."
    sudo tar --numeric-owner -xpxzvf "$BACKUP_NAME_DOCKER" -C .
    # Asegurar que la carpeta data desempaquetada mantenga el propietario correcto localmente
    sudo chown -R 1000:1000 ./data

    # 5. Restaurar el cortafuegos UFW exactamente con tus puertos actuales
    echo "[*] Aplicando reglas de cortafuegos UFW..."
    sudo tar --numeric-owner -xpxzvf "$BACKUP_NAME_UFW" -C /
    sudo ufw enable
    sudo systemctl enable --now ufw
    sudo ufw reload

    # 6. Levantar todo el entorno
    echo "[*] Levantando los contenedores en Docker..."
    docker compose up -d

    echo ""
    echo "========================================================"
    echo "¡MIGRACIÓN COMPLETADA CON ÉXITO!"
    echo "========================================================"
    echo "Todo el entorno se ha restaurado idéntico y sin errores."
    echo "Las carpetas multimedia están listas para recibir descargas."
    echo "Puedes acceder a tus paneles habituales en los mismos puertos."
    echo "========================================================"
    exit 0
}

# Ejecutar el menú principal
mostrar_menu