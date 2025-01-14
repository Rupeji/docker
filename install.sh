#!/usr/bin/env bash
#-------------------------------------------------------------------------
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------
#Color		Texto	Fondo texto
#Black		30	40
#Red		31	41
#Green		32	42
#Yellow		33	43
#Blue		34	44
#Magenta	35	45
#Cyan		36	46
#Light Gray	37	47
#Gray		90	100
#Light Red	91	101
#Light Green	92	102
#Light Yellow	93	103
#Light Blue	94	104
#Light Magenta	95	105
#Light Cyan	96	106
#White		97	107

#Code	Descripción
#0	Reset/Normal
#1	Bold text
#2	Faint text
#3	Italics
#4	Underlined text

#Colores
Black="30"
Red="31"
Green="32"
Yellow="33"
Blue="34"
Magenta="35"
Cyan="36"
LightGray="37"
Gray="90"
LightRed="91"
LightGreen="92"
LightYellow="93"
LightBlue="94"
LightMagenta="95"
LightCyan="96"
White="97"

#Fondos
FBlack="40"
FRed="41"
FGreen="42"
FYellow="43"
FBlue="44"
FMagenta="45"
FCyan="46"
FLightGray="47"
FGray="100"
FLightRed="101"
FLightGreen="102"
FLightYellow="103"
FLightBlue="104"
FLightMagenta="105"
FLightCyan="106"
FWhite="107"

#-------------------------------------------------------------------------
#    Esto cambia los títulos
#
COLOR="${White}"
BGCOLOR="\e[${FBlue}m"
#
#-------------------------------------------------------------------------

#Esto es fijo para los títulos
BOLDCOLOR="\e[1;${COLOR}m"
BACKGROUND="\e[${BGCOLOR}"
ENDCOLOR="\e[0m"

#-------------------------------------------------------------------------
#
#   Esto cambia los colores de las pantallas de carga
#
Colorin="${White}"
ColorDeFondo="\e[${FCyan}m"
#
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
#   Esto es fijo paracambiar las pantallas de carga
#
ColorNegrita="\e[1;${Colorin}m"
Fondo="\e[${ColorDeFondo}"

#-------------------------------------------------------------------------
#   Esto es el color para el texto que muestra el comando 11
#
Once="\e[1;${Blue}m"
#
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
#   Esto mete una pausa al añadir "pausa" en el código
#
function pausa(){
read -p "$*"
}
#
#-------------------------------------------------------------------------

menu_choice=""
while [ "$menu_choice" != "17" ]
do
clear
echo
echo -e "${BOLDCOLOR}${BACKGROUND}Por favor, selecciona una opción${ENDCOLOR}"
echo
echo "1.  Crear carpetas y arreglar permisos" 
echo "2.  Instalar Docker y Openssh"
echo "3.  Instalar Docker-compose y Portainer"
echo "4.  Instalar Sonarr, Bazarr, Radarr y Prowlarr"
echo "5.  Instalar qBittorrent temporal"
echo "6.  Instalar qBittorrent permanente"
echo "7.  Instalar Wirehole"
echo "8.  Instalar Paru"
echo
echo "9.  Actualizar sistema"
echo "10.  Arreglar permisos a secas"
echo
echo "11. Salir"
echo

read menu_choice
clear
case $menu_choice in
        1)
            echo -e "${ColorNegrita}${Fondo}Creando carpetas...${ENDCOLOR}"
            echo
	    sudo pacman -Syu --noconfirm
	    sleep 1
	    cd
     	    mkdir arr
	    cd arr
     	    mkdir {data,Files}
	    cd data
     	    mkdir {media,torrents,usenet}
     	    mkdir -p media/{music,movies,tv}
     	    mkdir -p torrents/{music,movies,tv}
     	    mkdir -p usenet/{music,movies,tv}
     	    sleep 1
            echo -e "${ColorNegrita}${Fondo}Arreglando permisos...${ENDCOLOR}"
            sleep 1
	    cd
	    sudo chown -R inhumano:inhumano arr
     	    sudo chmod -R 775 arr
	    sleep 1
            echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para reiniciar...${ENDCOLOR}"
	    reboot
            ;;
        2)
            echo -e "${ColorNegrita}${Fondo}Instalando Docker y openssh${ENDCOLOR}"
            echo
	    sleep 2
	    sudo pacman -S docker nano neofetch openssh --noconfirm
	    sleep 1
	    sudo systemctl start docker.service
     	    sleep 1
     	    sudo systemctl start sshd
     	    sleep 1
	    sudo systemctl enable docker.service
            sleep 1
	    sudo systemctl enable sshd
	    sleep 1
	    sudo usermod -aG docker $USER
	    sleep 1
	    newgrp docker
	    sleep 1
            ;;
        3)
            echo -e "${ColorNegrita}${Fondo}Instalando Docker-Compose y Portainer${ENDCOLOR}"
            echo
	    sudo pacman -S docker-compose --noconfirm
	    sleep 1
	    docker run hello-world
	    sleep 2
     	    sudo docker pull portainer/portainer-ce:latest || error "Failed to pull latest Portainer docker image!"
     	    sudo docker run -d -p 9000:9000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest --logo "https://upload.wikimedia.org/wikipedia/commons/5/5d/Al-logo.svg" || error "Failed to run Portainer docker image!"
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        4)
            echo -e "${ColorNegrita}${Fondo}Instalando Sonarr, Bazarr, Radarr y Prowlarr${ENDCOLOR}"
	    sleep 1            
	    cd
     	    cd docker
	    cd arr
     	    docker compose up -d
	    echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        5)  
            echo -e "${ColorNegrita}${Fondo}Instalando qBittorrent de forma temporal${ENDCOLOR}"
            echo
	    sleep 2            
	    cd
     	    cd docker
	    cd qBittorrent
     	    docker compose up
	    echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        6)  
            echo -e "${ColorNegrita}${Fondo}Instalando qBittorrent permanente${ENDCOLOR}"
            echo
	    sleep 2            
	    cd
     	    cd docker
	    cd qBittorrent
     	    docker compose up -d
	    echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        7)  
            echo -e "${ColorNegrita}${Fondo}Instalando Pihole${ENDCOLOR}"
            echo
	    sleep 2            
	    cd
     	    cd docker
	    cd Wirehole
     	    docker compose up -d
	    echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        8)  
            echo -e "${ColorNegrita}${Fondo}Instalando Paru${ENDCOLOR}"
            echo
	    sleep 2            
	    cd "$HOME" || exit
	    git clone https://aur.archlinux.org/paru-bin.git
	    cd paru-bin || exit
	    makepkg -si --noconfirm
	    echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        9)  
            echo -e "${ColorNegrita}${Fondo}Actualizando sistema...${ENDCOLOR}"
            echo
	    sudo pacman -Syu --noconfirm
	    echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
            echo
	    pausa
            ;;
        10)  
            echo -e "${ColorNegrita}${Fondo}Arreglando permisos...${ENDCOLOR}"
            sleep 1
	    cd
	    sudo chown -R inhumano:inhumano arr     
	    sudo chown -R inhumano:inhumano JDownloader
	    sudo chown -R inhumano:inhumano filebrowser
	    sudo chown -R inhumano:inhumano Descargas
	    sudo chown -R inhumano:inhumano Wireguard
	    sudo chown -R inhumano:inhumano Pihole
	    sudo chown -R inhumano:inhumano Duckdns
	    sudo chmod -R 775 Pihole
     	    sudo chmod -R 775 Duckdns     
            sudo chmod -R 775 Descargas
     	    sudo chmod -R 775 Wireguard
     	    sudo chmod -R 775 arr
     	    sudo chmod -R 775 JDownloader
	    sudo chmod -R 775 filebrowser
	    sleep 1
            echo
	    echo -e "${BOLDCOLOR}${BACKGROUND}Pulsa [Enter] para continuar...${ENDCOLOR}"
	    pausa
            ;;
        11)
            echo -e "${ColorNegrita}${Fondo}Chao pescao${ENDCOLOR}"
            echo
	    sleep 2
            clear
	    exit
            ;;
    esac
done
