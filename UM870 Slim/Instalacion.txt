Paso 1: 
Conexión Inicial por SSH a la ISO de Arch Linux
Cuando arranques el Mini PC con el USB de Arch Linux, no necesitas tener un monitor pegado en el salón. 
Si está conectado por cable al switch Mercusys, obtendrá una IP automáticamente.
En la pantalla del Mini PC (o a ciegas si conoces la IP de tu router) ponle una contraseña temporal al usuario root escribiendo: passwd
Averigua la IP asignada: ip a
Vete a tu ordenador principal y conéctate por SSH:

ssh root@192.168.50.150  # La IP temporal que te haya dado el router

Paso 2: El Secreto Práctico — Preparar el LVM2 antes de abrir el instalador
Para conseguir nuestro mapa híbrido de formatos (Btrfs para el sistema y Ext4 para datos), ejecuta estos comandos en la terminal SSH. 
Asumiremos que tu SSD WD Blue de 4TB es reconocido como /dev/nvme0n1 (puedes verificarlo con lsblk).

lsblk

# 1. Limpiar el disco por completo
sgdisk --zap-all /dev/nvme0n1

# 2. Crear las dos particiones físicas: EFI (512MB) y el resto para LVM2
sgdisk -n 1:0:+512M -t 1:ef00 /dev/nvme0n1
sgdisk -n 2:0:0     -t 2:8e00 /dev/nvme0n1

# 3. Formatear la partición EFI en FAT32 (obligatorio)
mkfs.vfat -F32 /dev/nvme0n1p1

# 4. Inicializar LVM2 en la partición 2 y crear el Grupo de Volúmenes (vg_sistema)
pvcreate /dev/nvme0n1p2
vgcreate vg_sistema /dev/nvme0n1p2

# 5. Crear los Volúmenes Lógicos con los tamaños exactos pactados
lvcreate -L 250G -n lv_root vg_sistema
lvcreate -L 2.3T -n lv_lancache vg_sistema
lvcreate -L 1.2T -n lv_jellyfin vg_sistema

# 6. Dar formato independiente a cada Volumen Lógico (Híbrido Btrfs/Ext4)
mkfs.btrfs -L ROOT /dev/vg_sistema/lv_root
mkfs.ext4 -L LANCACHE /dev/vg_sistema/lv_lancache
mkfs.ext4 -L JELLYFIN /dev/vg_sistema/lv_jellyfin

Paso 3: Configuración Guiada dentro de archinstall
Ahora que el disco está perfectamente estructurado y formateado, lanza el comando:

archinstall

Muévete por los menús configurando exactamente los siguientes apartados:
Language & Keyboard: Selecciona Spanish para el teclado.
Mirrors: Selecciona Spain para que las descargas de paquetes vuelen.
Disk configuration (CRÍTICO):Elige "Pre-mounted configuration" (Configuración premontada) o selecciona "Manual partitioning".
Como ya hemos formateado todo en el Paso 2, debes asignar los puntos de montaje a lo que ya existe:
Mapea /dev/nvme0n1p1 como /boot.Mapea /dev/vg_sistema/lv_root como / (la raíz).

IMPORTANTE: No mapees los volúmenes de LanCache ni Jellyfin aquí dentro de archinstall. 
Los montaremos manualmente en el /etc/fstab real más tarde para que el instalador no se líe.
Bootloader: Selecciona systemd-boot. 
Es el más limpio, moderno y el que mejor se adapta a nuestra partición EFI optimizada.
Kernel: Selecciona linux (el kernel normal que acordamos).
Network configuration: Selecciona Use systemd-networkd. 
Esto es vital para que podamos meter nuestra IP fija y nuestra IP secundaria virtual de forma nativa a través del sistema de red de Systemd.
Profile: Selecciona Minimal (queremos un servidor headless limpio, sin entornos gráficos ni bloatware).
Audio / Graphics: Deja el audio por defecto. 
En Graphics selecciona AMD / ATI (open-source) (esto instalará el driver xf86-video-amdgpu e iniciará el soporte nativo para tu Radeon 780M RDNA3).
Root password & User account:Define una contraseña fuerte para root.
Crea tu usuario personal (ej. tu_usuario), dale permisos de administrador (sudo) y ponle contraseña.
Additional packages (MÁS CRÍTICO AÚN): Escribe aquí los paquetes esenciales que el instalador debe inyectar para que tu servidor sea accesible y rinda al máximo desde el minuto uno. 
Añade exactamente esta lista separada por espacios:

openssh docker docker-compose lvm2 mesa libva-mesa-driver vulkan-radeon git btrfs-progs nano tmux

¿Por qué estos? openssh (para no perder el acceso SSH al reiniciar), docker y docker-compose (para nuestro stack),
lvm2 y btrfs-progs (para que el sistema entienda tus formatos de disco), 
y mesa libva-mesa-driver vulkan-radeon (los drivers de aceleración de vídeo por hardware VA-API obligatorios para 
que Jellyfin transcodifique 4K usando la Radeon 780M).
Services: Asegúrate de activar sshd para que el servidor SSH arranque automáticamente al encender el equipo.
Dale a Install y deja que ocurra la magia.

Paso 4: Remate final antes de reiniciar (El toque maestro)
Cuando archinstall termine, te preguntará: "Do you want to chroot into the newly created installation?". 
Dile que SÍ (Yes). 
Entrarás a la línea de comandos del nuevo sistema operativo antes de encenderlo por primera vez. 
Ejecuta estos dos últimos retoques:

# 1. Habilitar Docker para que arranque solo
systemctl enable docker

# 2. Crear las carpetas y dejar listos los montajes automáticos de tus discos de datos
mkdir -p /mnt/storage_4tb/lancache
mkdir -p /mnt/storage_4tb/media

# Añadir al fstab para que se monten solos al arrancar
echo "/dev/vg_sistema/lv_lancache /mnt/storage_4tb/lancache ext4 defaults,noatime 0 2" >> /etc/fstab
echo "/dev/vg_sistema/lv_jellyfin /mnt/storage_4tb/media ext4 defaults,noatime 0 2" >> /etc/fstab

Escribe exit, luego reinicia el Mini PC con reboot y retira el USB.
Tu servidor headless estará completamente instalado, protegido con LVM2/Btrfs, 
con los drivers de video listos para Jellyfin y esperando en tu red local.

-----------------------------------------------------------------------------
Tras reiniciar

Aquí tienes el archivo de configuración exacto que tendrás que crear. 
En Arch Linux con systemd-networkd, debes crear un archivo terminado 
en .network dentro de /etc/systemd/network/.
Fichero de red definitivo: 
/etc/systemd/network/20-wired.network(Asumiendo que tu tarjeta de red a 2.5 Gbps se llama enp2s0 o similar, 
lo cual puedes verificar en el paso 1 con el comando ip a).

nano .networkt


ini
[Match]
Name=enp* # Esto engancha automáticamente cualquier tarjeta de red por cable (ethernet)

[Network]
# IP Principal del Servidor (Para Arch, AdGuard, Jellyfin)
Address=192.168.50.150/24

# IP Secundaria Virtual (Reservada en exclusiva para LanCache en Docker)
Address=192.168.50.151/24

# La IP de tu router de casa para que el servidor tenga salida a internet
Gateway=192.168.50.1

# Servidor DNS temporal para que el propio Minisforum pueda resolver nombres 
# (Apuntamos a Cloudflare para que el sistema baje actualizaciones de Arch y Docker)
DNS=1.1.1.1

Una vez creado ese archivo con tu nuevo editor nano, solo tendrás que reiniciar 
el servicio de red para que el Minisforum adquiera ambos superpoderes simultáneamente en el mismo cable:


systemctl restart systemd-networkd


Si tiras un ip a, verás que tu tarjeta de red física ahora tiene las dos IPs asignadas 
de forma permanente y limpia, preparándole el terreno perfecto a nuestro compose.yaml.

