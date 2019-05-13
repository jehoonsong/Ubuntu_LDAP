FROM ubuntu:18.04
MAINTAINER Je-Hoon Song <jehoon.song@net-targets.com>
RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y nano openssh-server openssh-client sudo git wget curl
RUN DEBIAN_FRONTEND=noninteractive apt-get install libpam-ldap nscd -y
COPY start.sh /root/start.sh
COPY lets-ldap /usr/local/bin/lets-ldap
RUN chmod 700 /usr/local/bin/lets-ldap
RUN chown root:root /usr/local/bin/lets-ldap
RUN chmod 777 /root/start.sh
RUN export DEBIAN_FRONTEND=gtk
# install default packages 
# the docker should be maintained as minimal packages
RUN apt-get install docker.io vim -y 

USER root 
EXPOSE 22

ENTRYPOINT "/root/start.sh"
