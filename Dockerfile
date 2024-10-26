# Imagen base: Ubuntu 20.04
FROM ubuntu:20.04

# Configuramos el entorno para evitar solicitudes interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos el sistema y instalamos Apache, Perl, y el módulo CGI
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    libcgi-pm-perl \
    && apt-get clean

# Habilitamos el módulo CGI de Apache
RUN a2enmod cgi

# Creamos el directorio cgi-bin y css en el contenedor
RUN mkdir -p /usr/lib/cgi-bin /var/www/html/css

# Copiamos los archivos de nuestro proyecto al contenedor
COPY ./cgi-bin/ /usr/lib/cgi-bin/
COPY ./index.html /var/www/html/
COPY ./styles.css /var/www/html/
COPY img /var/www/html/img

# Aseguramos que los scripts Perl en cgi-bin sean ejecutables
RUN chmod +x /usr/lib/cgi-bin/*.pl

# Exponemos el puerto 80 para el servidor web
EXPOSE 80

# Iniciamos Apache en primer plano para que siga corriendo en el contenedor
CMD ["apachectl", "-D", "FOREGROUND"]

