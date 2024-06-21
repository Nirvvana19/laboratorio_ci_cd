# Usar la imagen base de Nginx
FROM nginx:alpine

# Copiar el contenido HTML en el directorio de Nginx
COPY index.html /usr/share/nginx/html/index.html

# Exponer el puerto 8081
EXPOSE 8081

# Comando para ejecutar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
