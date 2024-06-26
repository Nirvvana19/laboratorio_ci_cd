# Usa la imagen base de Nginx
FROM public.ecr.aws/k5s1p6t5/nginx-mafe:latest

# Copia el archivo HTML directamente al directorio de Nginx
COPY index.html /usr/share/nginx/html/index.html

# Expone el puerto 80 para que Nginx pueda servir las páginas web
EXPOSE 80

# Comando por defecto para iniciar Nginx cuando se inicie el contenedor
CMD ["nginx", "-g", "daemon off;"]
