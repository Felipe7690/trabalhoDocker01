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

# Permitir tráfego na porta 22 (SSH)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Permitir tráfego na porta 80 (HTTP)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Permitir tráfego na porta 443 (HTTPS)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Bloquear todos os outros tipos de tráfego de entrada
iptables -A INPUT -j DROP

# Salvar configurações
iptables-save > /etc/iptables/rules.v4

# Mantenha o contêiner em execução
tail -f /dev/null
