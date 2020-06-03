#!/usr/bin/env bash

# To avoid "reset by peer message"
# zypper install openssh 
# zypper install sshfs

# date --set "24 Feb 2020 08:34:00"

# Note that you need to use "Ciphers=arcfour" if you want to accelerate network speed.
# Ubuntu Host PC: /etc/ssh/sshd_config (Ciphers aes128-ctr,arcfour256,arcfour128,arcfour)
OPTION="-o cache=yes -o kernel_cache -o compression=no -o Ciphers=arcfour"

sshfs $OPTION invain@10.113.221.122:/work/vivante/nnstreamer-private-plugins.git /mnt/sda2/nnstreamer-private-plugins.git

sshfs $OPTION invain@10.113.221.122:/work/vivante/vivante-neural-network-models.git /mnt/sda2/vivante-neural-network-models.git

