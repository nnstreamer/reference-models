#!/usr/bin/env bash

echo -e "Mounting a USB storage (/mnt/sda2) ..."
umount  /opt/media/USBDriveA1
umount  /opt/media/USBDriveA2
cat /etc/tizen-release
mkdir /mnt/sda1
mkdir /mnt/sda2
cat   /proc/partitions
mount /dev/sda2 /mnt/sda2
cd /mnt/sda2/setup

echo -e "Running an ethernet device (eth0) ..."
ls /sys/class/net/
sh ./ethernet.sh
sh ./dns.sh
sh ./proxy.sh
toybox ping www.naver.com
curl --insecure https://www.naver.com
curl http://download.tizen.org/snapshots/ 


echo -e "Installing zypper and Setting-up configuration ..."
cd zypper-rpms ; ./install.sh ; cd ..
rm -f /etc/zypp/repos.d/*.repo
cp ./zypp/repos.d/* /etc/zypp/repos.d/
rm -rf /var/cache/zypp*
rpmdb --rebuilddb
zypper clean
zypper refresh

echoe -e "Installing RPM packages...."
zypper install openssh
zypper install sshfs
zypper install ltrace
zypper install strace

