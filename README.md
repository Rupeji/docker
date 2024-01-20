# Guía paso a paso para configurar el bicho multimedia

Guía basada en este vídeo: `https://www.youtube.com/watch?v=Cth-bsLAa_M`

Tiene algún error, pero en mis archivos las rutas están bien. Sólamente sería cuestión de sustituir mi usuario por el de cada uno

### Prerequisitos

1. Instalación básica de Arch Linux
2. Mucha paciencia.

### Instalando qBittorrent

Necesitamos primero instalarlo de forma "temporal" para poder ver la contraseña temporal y poder loguear como usuario: admin y pass: CONTRASEÑA TEMPORAL

Para esto instalamos qBittorrent con la primera opción del instalador que dice "qBittorrent temporal"
![imagen](https://github.com/Rupeji/docker/assets/72431133/186cd833-348d-4b5e-a9ad-6c6b74d75d09)

Una vez cambiada la contraseña, bajamos abajo del menu y le damos a guardar.

Vamos a esta otra opción y lo dejamos así
![imagen](https://github.com/Rupeji/docker/assets/72431133/e3342b23-984b-488f-bc7f-dc6883fa3f1d)

Ahora toca hacer las categorías

![imagen](https://github.com/Rupeji/docker/assets/72431133/163ffdf6-75fa-4774-a04c-60215c83162d)

Hacemos click derecho debajo de CATEGORIES y le damos en añadir

![imagen](https://github.com/Rupeji/docker/assets/72431133/7fbb36d5-ddb5-4080-85ee-9d314fa4fe22)
![imagen](https://github.com/Rupeji/docker/assets/72431133/f6524cd5-eae4-4f08-9e48-342a864f6927)



1. Login to your portainer setup go to settings
2. 

### Information
All templates are already configured to bind mount to various places on your drive. This branch works without the need for OMV. The following folders are all created in /portainer/

* **Files** - General file storage.
  * **AppData** - Subfolder where application data (unrelated to served data) is stored.
    * **Config** - Subfolder where configuration files for every container are stored.
* **Downloads** - Where bittorrent and usenet downloaders download files to.
* **TV** - Where tv shows are stored/moved to after downloaded.
* **Movies** - Where movies are stored/moved to after downloaded.
* **Music** - Where music is stored/moved to after downloaded.
* **Books** - Where books are stored/moved to after downloaded.
* **Comics** - Where comics are stored/moved to after downloaded.
* **Podcasts** - Where podcasts are stored/moved to after downloaded.
## App List

  - Bazarr 
  - Filebrowser 
  - Headphones 
  - Homer 
  - Jellyfin
  - Jellyseerr
  - kodi-headless 
  - Lidarr 
  - Nextcloud 
  - Pihole 
  - Plex 
  - Plexrequests 
  - Prowlarr 
  - Qbittorrent 
  - Radarr 
  - Sonarr 


