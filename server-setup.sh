#!/bin/bash
# HamWAN Memphis Metro, Inc
# This is free and unencumbered software released into the public domain.
# 30 Jan 2015 de K0RET

zabbixserver=44.34.128.21
users=( ryan_turner ns4b )
monitor=monitor1.ret.memhamwan.net
nameservers="44.34.131.1 44.34.132.1"
echo "Please enter FQDN Hostname: "
read hostname

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -q -y upgrade
while true; do
    read -p "Is this a hypervisor, needing libvirt/kvm/qemu?" yn
    case $yn in
        [Yy]* ) apt-get -q -y install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virt-manager ; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
apt-get -q -y install zabbix-agent fail2ban

echo "Configuring Zabbix-Agent"
sed -i 's/Server=127.0.0.1/Server=$zabbixserver/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=$zabbixserver/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=Zabbix server/Hostname=$hostname/g' /etc/zabbix/zabbix_agentd.conf
service zabbix-agent restart
# Add users
for user in "${users[@]}"
do
        echo "Creating user $user"
        adduser --disabled-password --gecos "" $user
        mkdir /home/$user/.ssh/
        chmod 700 /home/$user/.ssh
        wget -O /home/$user/.ssh/authorized_keys http://memhamwan.org/wp-content/uploads/2014/11/${user}_dsa_public.txt
        chmod 600 /home/$user/.ssh/authorized_keys
        chown -R $user:$user /home/$user/.ssh
done

sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin without-password/PermitRootLogin no/g' /etc/ssh/sshd_config

service ssh restart

echo "@${monitor}:514" >> /etc/rsyslog.conf
service rsyslog restart

ufw allow 22
ufw allow 10050
ufw allow 10051
ufw enable

if [ -f "/etc/sudoers.tmp" ]; then
    exit 1
fi
touch /etc/sudoers.tmp
cp /etc/sudoers /tmp/sudoers.new
sed -i 's/ALL=(ALL:ALL) ALL/ALL=(ALL:ALL) NOPASSWD:ALL/g' /tmp/sudoers.new
visudo -c -f /tmp/sudoers.new

if [ "$?" -eq "0" ]; then
    cp /tmp/sudoers.new /etc/sudoers
fi
rm /etc/sudoers.tmp

echo "dns-nameservers ${nameservers}" >> /etc/network/interfaces
ifdown eth0 && ifup eth0
