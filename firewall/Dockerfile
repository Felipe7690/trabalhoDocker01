# Use a imagem base Ubuntu
FROM ubuntu:latest

# Atualize o repositório e instale o iptables
RUN apt-get update && apt-get install -y iptables

# Copie o script de firewall para dentro do container
COPY firewall.sh /root/firewall.sh

# Defina o script de firewall como executável
RUN chmod +x /root/firewall.sh

# Comando para executar o script de firewall
CMD ["/root/firewall.sh"]
