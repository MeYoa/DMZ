#!/bin/bash
# Workarround para solventar el error que aparece si en la definici´on de la red ponemos
# como gateway la IP de m´aquina que queremos que ejerza como tal (en este caso, fw).
# No podemos poner IPs repetidas en el fichero docker-compose.yml
route add default gw 10.5.1.1
route del default gw 10.5.1.254
service apache2 start
/usr/sbin/sshd -D