# Dockerfile para servidor DNS

# Usando a imagem base Ubuntu
FROM ubuntu:latest

# Atualizando o repositório e instalando o servidor DNS BIND9
RUN apt-get update && apt-get install -y bind9

# Copiando os arquivos de configuração do DNS para dentro do container
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
COPY db.example.com /etc/bind/db.example.com

# Criando o diretório /run/named e ajustando as permissões
RUN mkdir -p /run/named && chown -R bind:bind /run/named

# Expondo a porta usada pelo servidor DNS
EXPOSE 53/tcp
EXPOSE 53/udp

# Comando para iniciar o servidor DNS
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
