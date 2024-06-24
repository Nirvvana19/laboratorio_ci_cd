# Usa la imagen base de Nginx
FROM nginx:latest

# Copia tu archivo index.html al directorio de Nginx
COPY html /usr/share/nginx/html

# Exponer el puerto 8081
EXPOSE 8081

# Cambia el puerto de Nginx a 8081
RUN sed -i 's/listen       80;/listen       8081;/' /etc/nginx/conf.d/default.conf

# Inicia Nginx
CMD ["nginx", "-g", "daemon off;"]
