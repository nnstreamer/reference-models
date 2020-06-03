#!/usr/bin/env bash

# Author: Geunsik Lim <geunsik.lim@samsung.com>
# Workaround: Use a cross compiler of Ubuntu distribution  insted of fenix
#(the platform build environment of Khadas/VIM3)
# $ sudo apt install gcc-aarch64-linux-gnu
# 
rm -rf ./bin_r
echo -e "Compiling Inception V3 model for VIVANTE/VIM3 ...."
./build_vx.sh ~/npu/aml_npu_sdk/linux_sdk/linux_sdk ~/code/fenix
ls -al ./bin_r
