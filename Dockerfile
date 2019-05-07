from akhilrajmailbox/ubuntu:14.04
maintainer Akhil Raj <akhilrajmailbox@gmail.com>

run apt-get update && apt-get upgrade -y && apt-get install -y nano openssh-server openssh-client sudo git wget curl whiptail

run DEBIAN_FRONTEND=noninteractive apt-get install libpam-ldap nscd -y
copy start.sh /root/start.sh
copy lets-ldap /usr/local/bin/lets-ldap
run chmod 700 /usr/local/bin/lets-ldap
run chown root:root /usr/local/bin/lets-ldap
run chmod 777 /root/start.sh
run export DEBIAN_FRONTEND=gtk
entrypoint "/root/start.sh"
