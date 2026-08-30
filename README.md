Paso 1: Configurar la BIOS del Minisforum UN100L

Prepara el hardware para operar de forma autónoma como servidor doméstico continuo.
1.	Enciende el UN100L y pulsa repetidamente la tecla Supr (o F7) para entrar en la BIOS.
2.	Ve a la pestaña Advanced y busca ACPI Settings (o Power Management).
3.	Busca la opción State After G3 (o Power On after Power Failure) y cámbiala a Power On. (Esto garantiza que si hay un corte de luz en casa, el servidor se encenderá solo en cuanto vuelva la corriente).
4.	Asegúrate de que las opciones Intel VT-x e Intel VT-d estén en Enabled (esencial para Docker).
5.	Pulsa F10 para guardar los cambios y salir.
________________________________________
Paso 2: Instalación Base de Arch Linux

Introduce tu USB de instalación de Arch Linux y arranca el equipo.
1.	En la terminal de comandos de la ISO, escribe: archinstall y pulsa Enter.
2.	Configura las opciones básicas a tu gusto (idioma, teclado, región, discos).
3.	Puntos cruciales en el menú de archinstall:
o	Profile: Elige Server (sin entorno gráfico para liberar los 16GB de RAM).
o	Kernel: Selecciona obligatoriamente linux-lts (para máxima estabilidad).
o	Network configuration: Selecciona systemd-networkd y elige la opción Use DHCP. (Dejamos la red en modo automático porque el router se encargará de fijarla).
o	Additional packages: Escribe e instala estos tres paquetes esenciales: openssh, intel-ucode y git.
4.	Selecciona Install, espera a que finalice, retira el USB y reinicia el equipo.
________________________________________
Paso 3: Asignar la IP Estática en el Router ASUS

Congelaremos la dirección IP de tu servidor desde el panel de control del ASUS RT-AX53U.
1.	Conecta el Minisforum por cable Ethernet directamente al switch TP-Link, y este a un puerto LAN del router ASUS.
2.	Entra al panel de tu router ASUS desde el navegador de tu ordenador principal (normalmente en http://192.168.50.1).
3.	En el menú izquierdo, ve a Configuración Avanzada > LAN.
4.	Haz clic en la pestaña Servidor DHCP.
5.	Busca la sección Habilitar asignación manual y marca Sí.
6.	En la lista desplegable inferior (Dirección MAC), busca tu dispositivo Minisforum UN100L (o identifícalo por su dirección física MAC).
7.	En el cuadro de Dirección IP, escribe la IP fija que tendrá tu servidor: 192.168.50.100.
8.	Haz clic en el botón Añadir (+) y luego abajo del todo en Aplicar.
9.	Reinicia el mini PC escribiendo sudo reboot para que asuma su nueva identidad en la red.
A partir de este momento, retira el monitor y el teclado del Minisforum. Controlaremos todo de forma remota por SSH desde tu ordenador principal abriendo una terminal:
bash
ssh tu_usuario@192.168.50.100

________________________________________
Paso 4: Instalar Docker y Samba Nativo (Con Internet Activo)
Descargaremos todo el software necesario mientras el sistema operativo dispone de resolución DNS nativa.
1.	Actualiza los repositorios e instala Docker junto a los drivers de la gráfica integrada del Intel N100:
bash
sudo pacman -Syu docker docker-compose intel-media-driver libva-intel-driver
2.	Activa el motor de Docker en el arranque:
bash
sudo systemctl enable --now docker
3.	Instala y configura Samba de forma nativa para exprimir la velocidad Gigabit del switch:
bash
sudo pacman -S samba
sudo mkdir -p /srv/samba/compartido
sudo chown -R nobody:nobody /srv/samba/compartido
sudo chmod -R 777 /srv/samba/compartido
4.	Crea el archivo de configuración de almacenamiento:
bash
sudo nano /etc/samba/smb.conf
5.	Pega este bloque de configuración exacto:
   
ini
[global]
workgroup = WORKGROUP
server string = Minisforum UN100L
security = user
map to guest = Bad User

[Compartido]
path = /srv/samba/compartido
browsable = yes
writable = yes
guest ok = yes
read only = no
force user = nobody

6.	Inicia el servicio de almacenamiento en red:
bash
sudo systemctl enable --now smb
________________________________________
Paso 5: Preparar el archivo docker-compose.yml

Estructuramos el ecosistema de contenedores en tu directorio personal.

1.	Crea la carpeta de gestión:
bash
mkdir ~/homeserver && cd ~/homeserver
nano docker-compose.yml

2.	Pega el siguiente código completo sin la línea de versión obsoleta y con volúmenes protegidos para Postgres:
(Está en el github)

(Guarda con Ctrl+O, Enter y sal con Ctrl+X).
________________________________________
Paso 6: Liberar el Puerto 53 y Lanzar el Servidor
Realizaremos el cambio del resolvedor local e iniciaremos Docker consecutivamente para evitar que el sistema se quede sin conexión.
1.	Modifica el resolvedor nativo de Arch Linux:
bash
sudo nano /etc/systemd/resolved.conf
Usa el código con precaución.
2.	Busca la línea #DNSStubListener=yes, descoméntala eliminando el símbolo # y cámbiala a no:
ini
DNSStubListener=no

3.	Aplica el cambio de red:
bash
sudo systemctl restart systemd-resolved

4.	Lanza inmediatamente el despliegue de tus aplicaciones:
bash
docker compose up -d

Docker descargará todas las imágenes requeridas y levantará la infraestructura. Pi-hole tomará el control del puerto 53 de inmediato.
________________________________________
Panel de Control de tu Red Local
Tu suite de servicios domésticos está completamente operativa en tu IP estática. Puedes acceder a ellos abriendo tu navegador web desde cualquier dispositivo de la casa:
•	📌 Heimdall (Tu panel principal): http://192.168.50.100:8090
•	📸 Immich (Tus copias de fotos): http://192.168.50.100:2283
•	🛡️ Pi-Hole (Bloqueador y DNS): http://192.168.50
•	🐳 Portainer (Control de contenedores): https://192.168.50.100:9443
•	🌐 Nginx Proxy Manager: http://192.168.50.100:81 (Credenciales iniciales: admin@example.com / changeme)
•	📁 Samba (Almacenamiento compartido): Accede introduciendo la dirección \\192.168.50.100 desde el explorador de Windows o smb://192.168.50.100 desde el Finder de Mac.
Con todo el sistema en marcha de forma segura, ¿cómo prefieres proceder? Podemos configurar las DNS en tu router ASUS para activar el bloqueo de anuncios de Pi-hole en toda la casa, o bien empezar a enlazar tus servicios en Heimdall para dejar tu panel de inicio completamente configurado.
