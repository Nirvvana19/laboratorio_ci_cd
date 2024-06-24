# Usa la imagen base de Nginx
FROM nginx:latest

# Exponer el puerto 8080 
EXPOSE 8085

# Iniciar Nginx al iniciar el contenedor
CMD ["nginx", "-g", "daemon off;"]
