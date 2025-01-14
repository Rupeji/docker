# Guía paso a paso para configurar el bicho multimedia

Guía basada en este vídeo: https://www.youtube.com/watch?v=Cth-bsLAa_M

Aunque no lo tengo todo exacto, esta web tiene mucha info: https://trash-guides.info/

Tiene algún error, pero en mis archivos las rutas están bien. Sólamente sería cuestión de sustituir mi usuario por el de cada uno

## Prerequisitos

1. Instalación básica de Arch Linux
2. Mucha paciencia.

## Instalando y configurando qBittorrent

IP DE VUESTRA MÁQUINA:8080

Necesitamos primero instalarlo de forma "temporal" para poder ver la contraseña temporal y poder loguear como usuario: admin y pass: CONTRASEÑA TEMPORAL

Para esto instalamos qBittorrent con la primera opción del instalador que dice "qBittorrent temporal"

Veremos que la pantalla se queda como en la imagen inferior, luego sólo escopiarla e ir al qBittorrent y loguear por primera vez.

![imagen](https://github.com/Rupeji/docker/assets/72431133/e3f767b8-ba03-4c72-830d-c4ce1af24636)



![imagen](https://github.com/Rupeji/docker/assets/72431133/a2c07d3f-4d3e-4b6d-9fbe-e681fde22a8f)


Una vez cambiada la contraseña y dejadas todas las opciones como las de la imagen superior, bajamos abajo del menu y le damos a guardar.

Esta instalación de qBittorrent tiene dos Web UI instaladas que podemos seleccioanr: UI VueTorrent (/app/vuetorrent) y Nightwalker (/app/nightwalker). (Por defecto viene puesta la de Vuetorrent)

Podemos usar la visualización alternativa Vuetorrent si marcamos la opción de abajo de la imagen, pero eso cambia mucho la interface y es mejor cambiarla cuando esté todo configurado y lo queramos dejar bonito. Si ponemos la de Nightwalker, simplemente lo veremos todo modo oscuro y esta no afecta al tutorial.

Vamos a esta otra opción y lo dejamos así (le damos por abajo a guardar)

![imagen](https://github.com/Rupeji/docker/assets/72431133/1398fe3a-b43c-4edb-8724-fef273d0a871)


Ahora toca hacer las categorías

![imagen](https://github.com/Rupeji/docker/assets/72431133/650d15f0-fb19-4683-9bc7-cabf5a2cd1a3)

Hacemos click derecho debajo de CATEGORIES y le damos en añadir

![imagen](https://github.com/Rupeji/docker/assets/72431133/414d1711-c44b-4d73-8a1f-6c21ec2f92b6)

![imagen](https://github.com/Rupeji/docker/assets/72431133/204d13af-31db-423c-9d05-b376337bed39)

Decir que si queremos audiolibros/libros tendríamos que hacer sus respecvas categorías.

Ahora podemos volver a la terminal y pulsar dos veces 'ctrl+c' para terminar el proceso y hacer la instalación normal de qBittorrent.

![imagen](https://github.com/Rupeji/docker/assets/72431133/8c365c9d-8e26-4adc-99bd-9024afe57c3f)


Una vez instalado de forma normal, con esto ya estaría terminada la parte de qBittorent, pero por supuesto, se puede personalizar el idioma y el resto de opciones siempre y cuando mantengamos las que he indicado antes.


## Configurando Prowlarr

IP DE VUESTRA MÁQUINA:9696

Haremos una configuración mímima para que funcione con animes, el resto de contenido se configura de la misma manera

![imagen](https://github.com/Rupeji/docker/assets/72431133/ecb4aca2-eb52-4250-a32a-8a89dccfa882)

Pulsamos en "Add Indexer"

![imagen](https://github.com/Rupeji/docker/assets/72431133/6d56f910-4835-4d3a-89db-bc58a64377ec)

De aquí básicamente tenemos que seleccionar el idioma, privacidad y categorías para filtrar ver los servers que nos interesan

Ejemplo de añadir un server:

![imagen](https://github.com/Rupeji/docker/assets/72431133/1b13ec77-81b3-4221-bc0e-fefa2af56ee7)

En este caso añadimos "TheRARBG", para ello clickamos en el y se nos abrirá una ventana, en ella simplemente es seleccionar la "Base Url" y pulsar en "Test", si sale un tick verde, le damos a guardar y listo, sólo es repetir lo mismo con otros servidores. Una vez terminado de añadir servidores, procedemos a cerrar esa ventana.

![imagen](https://github.com/Rupeji/docker/assets/72431133/e467579b-c17b-4c41-97bc-cd6c211b341f)

Ahora en Apps, tenemos que añadir los "arr" (Sonarr, Radarr, etc)

![imagen](https://github.com/Rupeji/docker/assets/72431133/a2c4f612-c165-440a-b096-844453f7bfe8)

Añadiremos Sonarr, pero es lo mismo para el resto.

![imagen](https://github.com/Rupeji/docker/assets/72431133/3424c3a2-76b9-4ad6-ad01-1ce882924ace)

Aquí en azul por defecto pone "localhost", pero yo prefiero cambiarlo por la ip de nuestra máquina.

Luego en rojo, tenemos que copiar de Sonarr (o de la app que estemos añadirendo), la API Key que se encuentra en "settings" --> "General", está por abajo, la copiamos y pegamos en Prowlaar y le damos a test, si sale tick verde, le damos a guardar y listo.

![imagen](https://github.com/Rupeji/docker/assets/72431133/b1369479-894e-44a7-baed-54f5280de077)

Ahora nos vamos a "Download Clients" y le buscamos qBittorrent

![imagen](https://github.com/Rupeji/docker/assets/72431133/b13479e5-8fa3-4def-b5d4-ad2c49f324f5)

![imagen](https://github.com/Rupeji/docker/assets/72431133/016db6f8-1a20-414c-b4dd-33f50956aeff)

Aquí tenemos que añadir la IP de la máquina, el usuario con el que nos logueamos en qBittorrent y la contraseña nueva que cambiamos en el apartado de qBittorremt.

Pulsamos en "Test" y si sale el tick verde, pulsamos en "Save"

Con esto ya estaría configurado Prowlarr, pero al igual que dije en el apartado de qBittorrent, se pueden tocar más cosas como añadir notificaciones, etc.

## Configurando Sonarr

IP DE VUESTRA MÁQUINA:8989

![imagen](https://github.com/Rupeji/docker/assets/72431133/e7c03ad0-c8b9-4964-8e20-0f3bf3200308)

Comenzaremos añadiendo la carpeta donde queremos que se guarden las series

Serrings --> Media Management (bajamos abajo del todo) --> Add Root Folder

![imagen](https://github.com/Rupeji/docker/assets/72431133/bf2f8822-4dc6-460f-a6dd-c64916cdba18)

Pulsamos en Ok y se nos quedará en azulito como se ve en la captura de arriba en la parte de abajo izquierda.

Si subimos un poco dentro de la categoría en la que estamos, tenemos que asegurarnos de que los "Hardlinks" estén marcados como se ve a continuación:

![imagen](https://github.com/Rupeji/docker/assets/72431133/95a9d100-52f3-4798-9807-c4ad067fe2eb)

Vamos a "Profiles" y aquí lo suyo es que configuremos para que nos mejore calidades y tal, esto no es imprescindible para que funcione y busque series, pero estaría bien dedicarle un tiempo a configurar.

![imagen](https://github.com/Rupeji/docker/assets/72431133/39478db0-f075-45c1-a3bf-88a2f7131adb)

Ahora vamos a Download Clients y añadiremos el qBittorrent

![imagen](https://github.com/Rupeji/docker/assets/72431133/4182e436-c079-4ec8-bfea-2910dbe4f6bf)

![imagen](https://github.com/Rupeji/docker/assets/72431133/1f446d47-553a-44b9-8950-a4613f8ab014)

Aquí las opciones importantes son las marcadas en rojo, tenemos que poner nuestra IP en Host, usuario y contraseña de qBittorrent y super importante, que la categoría sea tv, ya que en qBittorrent lo tenemos así.

Una vez añadido todo, pulsamos en Test y si sale tick verde, en Save.

Con esto en un principio ya tenemos lo mínimo configurado.



















  - Bazarr 
  - Filebrowser 
  - Homer 
  - Jellyfin
  - Jellyseerr
  - kodi-headless 
  - Lidarr 
  - Pihole 
  - Prowlarr 
  - Qbittorrent 
  - Radarr 
  - Sonarr 


