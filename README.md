# Configuração de Rede em Docker

Este projeto consiste na configuração de um ambiente de rede em Docker para uma empresa fictícia. O ambiente inclui serviços essenciais de rede, como DHCP, DNS e Firewall, para garantir conectividade e segurança adequadas. Cada serviço é configurado em um contêiner Docker separado e há interação entre eles para permitir a comunicação adequada.

# Passos do Projeto
- Configurar um servidor DHCP em um contêiner Docker.
- Configurar um servidor DNS em um contêiner Docker.
- Configurar um firewall em um contêiner Docker para proteger a rede.
- Garantir a interação entre os contêineres para permitir a comunicação adequada entre DHCP, DNS e - firewall.
- Criar Dockerfiles para cada imagem necessária, utilizando como base a imagem ubuntu:latest, e incluir - todas as configurações e dependências necessárias.
- Realizar testes para garantir que a configuração da rede esteja funcionando corretamente, incluindo testes de conectividade, resolução de nomes de domínio e aplicação das regras de firewall.

# Dockerfiles e Configurações
## DHCP
O serviço DHCP é configurado usando a imagem base Ubuntu. O Dockerfile para o DHCP inclui os seguintes passos:

- Atualização do repositório e instalação do servidor DHCP (isc-dhcp-server).
- Criação e permissões do arquivo dhcpd.leases.
- Definição do arquivo de configuração dhcpd.conf.
- Exposição da porta UDP 67.
- Comando de inicialização do servidor DHCP.

## Arquivo de Configuração do DHCP (Dockerfile)

```FROM ubuntu:latest

# Instalar o servidor DHCP e outras dependências, se necessário
RUN apt-get update && apt-get install -y isc-dhcp-server

# Cria o arquivo dhcpd.leases e define as permissões
RUN touch /var/lib/dhcp/dhcpd.leases && \
    chmod 666 /var/lib/dhcp/dhcpd.leases

# Adicione outros comandos necessários para configurar o servidor DHCP, como copiar o arquivo dhcpd.conf para o local apropriado, etc.

# Comando de inicialização do servidor DHCP (por exemplo, pode ser um script de inicialização)
CMD ["/usr/sbin/dhcpd", "-f", "-d", "--no-pid"]

# Se houver outros serviços ou configurações necessárias, adicione-os aqui


```

## Arquivo de Configuração do DHCP (dhcpd.conf)


```
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200; # Faixa de endereços a serem atribuídos aos clientes
  option routers 192.168.1.1; # Gateway padrão
  option domain-name-servers 8.8.8.8, 8.8.4.4; # Servidores DNS
  option domain-name "example.com"; # Nome de domínio
  default-lease-time 600; # Tempo de concessão de endereço padrão (em segundos)
  max-lease-time 7200; # Tempo máximo de concessão de endereço (em segundos)
}
```


# DNS
O serviço DNS é configurado usando a imagem base Ubuntu. O Dockerfile para o DNS inclui os seguintes passos:

- Atualização do repositório e instalação do servidor DNS (bind9).
- Cópia dos arquivos de configuração para dentro do container.
- Criação do diretório /run/named e ajuste das permissões.
- Exposição da porta TCP e UDP 53.
- Comando de inicialização do servidor DNS.

## Arquivo Dockerfile

```# Dockerfile para servidor DNS

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

```

## Arquivos de Configuração do DNS
- named.conf.options: Configuração das opções do BIND9.
```
options {
    directory "/var/cache/bind";

    // Seu provedor de DNS público ou outros servidores DNS
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Definindo as permissões para consultas externas
    allow-query {
        any;
    };
};

```
- named.conf.local: Configuração das zonas locais.
```
zone "example.com" {
    type master;
    file "/etc/bind/zones/example.com.zone";
};

```
- db.example.com: Zona de exemplo para o domínio example.com.
```
;
; Arquivo de zona para example.com
;

$TTL    604800
@       IN      SOA     ns1.example.com. admin.example.com. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL

; Definições de servidores de nomes
@       IN      NS      ns1.example.com.

; Mapeamento de nomes para endereços IP
ns1     IN      A       192.0.2.1

```



# Firewall
O serviço de firewall é configurado usando a imagem base Ubuntu. O Dockerfile para o Firewall inclui os seguintes passos:

- Atualização do repositório e instalação do utilitário iptables.
- Cópia do script de firewall para dentro do container.
- Definição do script como executável.
- Comando para executar o script de firewall.

## Script de Firewall (Dockerfile)

```
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

```

## Script de Firewall (firewall.sh)

```
bash
Copy code
#!/bin/bash

# Limpar todas as regras existentes
iptables -F

# Definir políticas padrão
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfego de loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir conexões estabelecidas e relacionadas
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Permitir tráfego nas portas SSH, HTTP e HTTPS
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Bloquear todos os outros tipos de tráfego de entrada
iptables -A INPUT -j DROP

# Salvar configurações
iptables-save > /etc/iptables/rules.v4

# Manter o contêiner em execução
tail -f /dev/null

```
# Testes Realizados
Para validar a configuração da rede, foram realizados os seguintes testes:

- Teste de conectividade entre os contêineres DHCP, DNS e Firewall.
- Teste de resolução de nomes usando o servidor DNS.
- Teste de aplicação das regras de firewall, verificando o acesso a serviços específicos (SSH, HTTP, HTTPS).

# Execução do Projeto
Para executar o projeto, siga os seguintes passos:

Clone o repositório para sua máquina local.
- Navegue até o diretório do projeto.
- Construa as imagens Docker usando docker build.
- Inicie os contêineres usando docker run.
- Realize os testes de conectividade, resolução de nomes e aplicação de regras de firewall conforme descrito acima.
