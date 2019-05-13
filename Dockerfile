from ubuntu:18.04
maintainer Je-Hoon Song <jehoon.song@net-targets.com>
run apt-get update && apt-get upgrade -y \
	&& apt-get install -y nano openssh-server openssh-client sudo git wget curl
run DEBIAN_FRONTEND=noninteractive apt-get install libpam-ldap nscd -y
copy start.sh /root/start.sh
copy lets-ldap /usr/local/bin/lets-ldap
run chmod 700 /usr/local/bin/lets-ldap
run chown root:root /usr/local/bin/lets-ldap
run chmod 777 /root/start.sh
run export DEBIAN_FRONTEND=gtk

EXPOSE 22

USER root 

entrypoint "/root/start.sh"

