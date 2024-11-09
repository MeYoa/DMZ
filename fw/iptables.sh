#!/bin/bash

# Activación del bit de forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Cambiar la política por defecto de las cadenas INPUT y FORWARD para que descarten los paquetes.
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Cambiar la política de OUTPUT para que permita pasar todos los paquetes.
iptables -P OUTPUT ACCEPT

# Permitir el tráfico entrante a través de la interfaz de loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir el tráfico entrante correspondiente a cualquier conexión previamente establecida.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir consultas entrantes de tipo ICMP ECHO REQUEST.
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Permitir todo el tráfico de conexiones establecidas y relacionadas para TCP, UDP Y ICMP
iptables -A FORWARD -m state --state ESTABLECIDAS,RELATED -p tcp -j ACCEPT
iptables -A FORWARD -m state --state ESTABLECIDAS,RELATED -p udp -j ACCEPT
iptables -A FORWARD -m state --state ESTABLECIDAS,RELATED -p icmp -j ACCEPT 

# Permitir todo el tráfico que entre en el firewall a través de la interfaz con la red interna, con protocolo
# TCP, UDP o ICMP con dirección IP origen en el rango 10.5.2.0/24 y que vaya a salir a través de la interfaz
# la red externa
iptables -A FORWARD -i eth2 -p tcp -s 10.5.2.0/24 -d 10.5.0.0/24 -o eth1 -m state --state NEW -j ACCEPT
iptables -A FORWARD -i eth2 -p udp -s 10.5.2.0/24 -d 10.5.0.0/24 -o eth1 -m state --state NEW -j ACCEPT
iptables -A FORWARD -i eth2 -p icmp -s 10.5.2.0/24 -d 10.5.0.0/24 -o eth1 -m state --state NEW -j ACCEPT
