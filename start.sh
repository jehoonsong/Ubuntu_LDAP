#!/bin/bash
A=$(tput sgr0)
export TERM=xterm

## checking whether the server is configured with ldap or not

if [ ! -e /etc/ldap-bootstrapped ]; then
echo "configuring ldap-client for first run"

## checking the environment variable for non-interactive ldap-client configuration

 if [[ $BASE_DN != "" || $URI != "" || $ROOT_ADDCOUNT != "" || $ROOT_PASSWORD != "" || $BASE_GROUP != "" ]]; then
echo ""
[ -z "$BASE_DN" ] || echo -e '\E[32m'"BASE_DN (Base Distinguished name) value is : $BASE_DN $A"
[ -z "$BASE_GROUP" ] || echo -e '\E[32m'"BASE_GROUP (NSS Base Group) value is : $BASE_GROUP $A"
[ -z "$URI" ] || echo -e '\E[32m'"URI (Uniform Resource Identifier) value is : $URI $A"
[ -z "$ROOT_ADDCOUNT" ] || echo -e '\E[32m'"ROOT_ADDCOUNT (LDAP account for root) value is : $ROOT_ADDCOUNT $A"
[ -z "$ROOT_PASSWORD" ] || echo -e '\E[32m'"ROOT_PASSWORD (LDAP root account password) value is : $ROOT_PASSWORD $A"
echo ""

## ldap-client configuration in '/etc/ldap.conf' file

cp /etc/ldap.conf /etc/ldap.conf-org
cat <<EOF > /etc/ldap.conf
###DEBCONF###
##
## Configuration of this file will be managed by debconf as long as the
## first line of the file says '###DEBCONF###'
##
## You should use dpkg-reconfigure to configure this file via debconf
##

base $BASE_DN
uri $URI
ldap_version 3
rootbinddn $ROOT_ADDCOUNT
pam_password md5

# Group to enforce membership of
nss_base_group $BASE_GROUP

EOF

chmod 600 /etc/ldap.conf

## ldap admin password storing in config file '/etc/ldap.secret'

echo $ROOT_PASSWORD > /etc/ldap.secret && chmod 600 /etc/ldap.secret

## editing the file '/etc/nsswitch.conf' will allow us to specify that 
# the LDAP credentials should be modified when users issue 
# authentication change commands.

cp /etc/nsswitch.conf /etc/nsswitch.conf-org
cat <<EOF > /etc/nsswitch.conf
# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the "glibc-doc-reference" and info packages installed, try:
# 'info libc "Name Service Switch"' for information about this file.

passwd:         ldap compat
group:          ldap compat
shadow:         ldap compat

hosts:          files dns
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
EOF

## This will create a home directory on the client machine when 
# an LDAP user logs in who does not have a home directory.
echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
sed -i "s|use_authtok||g" /etc/pam.d/common-password
 else

## interactive configuration for ldap-client
echo -e '\E[32m'"Run 'lets-ldap' for manual configuration of ldap client $A"
 fi
echo "do not remove this file" >> /etc/ldap-bootstrapped
fi

## restarting services

/etc/init.d/ssh restart
/etc/init.d/nscd restart

tail -f /root/start.sh


# reference ::

#base dc=akhil,dc=system,dc=local 			(Distinguished name)		BASE_DN
#uri ldap://192.168.1.106:8995 				(Uniform Resource Identifier)	URI
#rootbinddn cn=admin,dc=akhil,dc=system,dc=local 	(LDAP account for root)		ROOT_ADDCOUNT
#(in '/etc/ldap.secret' file)				(LDAP root account password)	ROOT_PASSWORD
#ldap_version 3
#pam_password md5
