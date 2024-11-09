FROM ubuntu:22.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano \
    iproute2 iptables libxtables-dev libip6tc-dev libip4tc-dev pkg-config nmap tcpdump apache2 wget curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
WORKDIR /root
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh

EXPOSE 22

COPY ./start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]