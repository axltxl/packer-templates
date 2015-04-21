#!/bin/bash
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

# Build tools for virtualbox guest aditions
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl

cd /tmp
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso