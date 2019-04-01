#!/bin/bash

# This script runs inside a chroot and sets up a bootstrapped centos image.

yum -y -q --releasever=7 install yum centos-release

# ADD EPEL repo for extra packages (https://fedoraproject.org/wiki/EPEL)
# This is to pick up extra packages including security updates provided by
# RedHat
yum -y install epel-release

yum install -q -y bind-utils     bash     yum     vim-minimal     centos-release     less     iputils     iproute     systemd     rootfiles     tar     passwd     yum-utils     yum-plugin-ovl    hostname
yum -q -y erase kernel*     *firmware     firewalld-filesystem     os-prober     gettext*     GeoIP     bind-license     freetype     libteam     teamd
rpm -e kernel
yum -y remove bind-libs bind-libs-lite dhclient dhcp-common dhcp-libs   dracut-network e2fsprogs e2fsprogs-libs ebtables ethtool file   firewalld freetype gettext gettext-libs groff-base grub2 grub2-tools   grubby initscripts iproute iptables kexec-tools libcroco libgomp   libmnl libnetfilter_conntrack libnfnetlink libselinux-python lzo   libunistring os-prober python-decorator python-slip python-slip-dbus   snappy sysvinit-tools which linux-firmware GeoIP firewalld-filesystem   qemu-guest-agent
yum clean all
rm -rf /var/cache/yum
rm -rf /boot
rm -rf /etc/firewalld
passwd -l root
echo 'container' > /etc/yum/vars/infra
rm -rf /var/cache/yum/x86_64
rm -f /tmp/ks-script*
rm -rf /etc/sysconfig/network-scripts/ifcfg-*
rm -rf /etc/udev/hwdb.bin
rm -rf /usr/lib/udev/hwdb.d/*
:> /etc/machine-id
umount /run
systemd-tmpfiles --create --boot
rm /var/run/nologin
rpm --rebuilddb
rm /etc/resolv.conf

rm -rf /root/.bash_history
