#!/usr/bin/env bash

# Install the VMWare Tools.
printf "Installing the VMWare Tools.\n"

yum install -y open-vm-tools fuse-libs libdnet libicu libmspack
systemctl enable vmtoolsd
systemctl start vmtoolsd

#mkdir -p /mnt/vmware; error
#mount -o loop /root/linux.iso /mnt/vmware; error

#cd /tmp; error
#tar xzf /mnt/vmware/VMwareTools-*.tar.gz; error

#umount /mnt/vmware; error
#rm -rf /root/linux.iso; error

#/tmp/vmware-tools-distrib/vmware-install.pl -d; error
#rm -rf /tmp/vmware-tools-distrib; error

# Fix the SSH NAT issue on VMWare systems.
#printf "\nIPQoS lowdelay throughput\n" >> /etc/ssh/sshd_config

