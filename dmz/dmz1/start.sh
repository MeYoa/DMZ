#!/bin/bash
# Workarround para solventar el error que aparece si en la definici´on de la red ponemos
# como gateway la IP de m´aquina que queremos que ejerza como tal (en este caso, fw).
# No podemos poner IPs repetidas en el fichero docker-compose.yml
route add default gw 10.5.1.1
route del default gw 10.5.1.254
service rsyslog start
service apache2 start
service fail2ban start          # THIS IS NOT WORKING (Need Manual start in the container)

#iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
#sudo iptables -t nat -A PREROUTING -p tcp --dport 23 -j REDIRECT --to-port 2223

/usr/sbin/sshd -D