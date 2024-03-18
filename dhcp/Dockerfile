FROM ubuntu:latest

# Instalar o servidor DHCP e outras dependências, se necessário
RUN apt-get update && apt-get install -y isc-dhcp-server

# Cria o arquivo dhcpd.leases e define as permissões
RUN touch /var/lib/dhcp/dhcpd.leases && \
    chmod 666 /var/lib/dhcp/dhcpd.leases

# Adicione outros comandos necessários para configurar o servidor DHCP, como copiar o arquivo dhcpd.conf para o local apropriado, etc.

# Comando de inicialização do servidor DHCP (por exemplo, pode ser um script de inicialização)
CMD ["/usr/sbin/dhcpd", "-f", "-d", "--no-pid"]

# Se houver outros serviços ou configurações necessárias, adicione-os aqui

