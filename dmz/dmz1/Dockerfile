# Cambiar a Ubuntu 22.04
FROM ubuntu:22.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano \
    iproute2 iptables libxtables-dev libip6tc-dev libip4tc-dev pkg-config nmap \
    tcpdump apache2 wget curl libpam-google-authenticator fail2ban rsyslog git gcc \
    musl-dev python3-dev python3-virtualenv libssl-dev libffi-dev build-essential \
    libpython3-dev python3-minimal authbind virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

# Creamos un usuario no root
RUN useradd -m -d /home/user1 -s /bin/bash user1
RUN echo 'user1:user1' |chpasswd

WORKDIR /root
RUN mkdir /root/.ssh
RUN mkdir /home/user1/.ssh

# Hardening OpenSSH Server
COPY ./sshd_config /etc/ssh/sshd_config
COPY ./id_rsa.pub .
RUN cat id_rsa.pub > /root/.ssh/authorized_keys
RUN cat id_rsa.pub > /home/user1/.ssh/authorized_keys
RUN chmod 640 /root/.ssh/authorized_keys
COPY ./banner /etc/ssh/
COPY ./sshd /etc/pam.d/

# Fail2ban
COPY ./jail.conf /etc/fail2ban/

# HTTPS Config (Optional)
COPY ./index.html /var/www/html/
RUN mkdir /etc/apache2/certificate
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/apache2/certificate/apache-certificate.crt -keyout /etc/apache2/certificate/apache.key -subj "/C=ES/ST=CYL/L=Leon/O=ULE/CN=ypital00"
COPY ./000-default.conf /etc/apache2/sites-available/
# Solucionar error de apache2: Invalid command 'SSLProxyEngine', perhaps misspelled or defined by a module not included in the server configuration
RUN a2enmod ssl 

# Cowrie Honeypot
RUN useradd -m -d /home/cowrie -s /bin/bash cowrie

RUN su - cowrie && cd /home/cowrie && git clone http://github.com/cowrie/cowrie

ADD ./cowrie.cfg /home/cowrie/cowrie/etc/cowrie.cfg
ADD ./userdb.txt /home/cowrie/cowrie/etc/userdb.txt

RUN cd /home/cowrie/cowrie && virtualenv --python=python3 cowrie-env && . cowrie-env/bin/activate && pip install --upgrade pip  && pip install --upgrade -r requirements.txt

RUN chown -R cowrie:cowrie /home/cowrie

#RUN su cowrie && /home/cowrie/cowrie/bin/cowrie start       You must not run cowrie as root!


COPY ./start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]