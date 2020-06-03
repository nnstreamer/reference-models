#!/usr/bin/env bash

## @brief The build script for VIM3/Ubuntu 18.04 (aarch64)
#  @Author Geunsik Lim <geunsik.lim@samsung.com>
#
#  @note
#  This script currently supports two platforms as following:
#  Ubuntu 18.04 ARM 64bit on VIM3 board (Vivante)
#     - cross compile
#     - ubuntu$ sudo apt install gcc-aarch64-linux-gnu
#


# ---------------------- Initialization area -------------------------------------
rm -rf ./bin_r/
mkdir  ./bin_r/

# ---------------------- configuration area -------------------------------------

# Step 1/2
vivante_vim3_ubuntu=1
vivante_da_tizen=0 # Deprecated. Please use mybuild-tizen.sh file instead of this file.

# Step 2/2
shared=1

# Handle one between Ubuntu/ARM and Tizen/ARM
if [[ $vivante_vim3_ubuntu -eq 1 ]]; then
    export header_dir="/home/invain/npu/aml_npu_sdk"
    export compiler="aarch64-linux-gnu-gcc -g"
    export compile_flag="-mtune=cortex-a53 -march=armv8-a"
elif [[ $vivante_da_tizen -eq 1 ]]; then
    export header_dir="/opt/usr"
    export compiler="gcc -g"
    export compile_flag=""
else
    echo -e "Oooops, please specify one between Ubuntu/VIM3 and Tizen/VIM3."
    exit 1
fi

# Handle one between dynaming linking and static linking (ELF).
if [[ $shared -eq 1 ]]; then
    export pic_set="-fPIC"
    export shared_set="-shared"
else
    export pic_set=" "
    export shared_set=" "
fi

# ---------------------- build area -----------------------------------------------


 export conf_option="-DLINUX -Wall -D_REENTRANT -fno-strict-aliasing $compile_flags -DgcdENABLE_3D=1 -DgcdENABLE_2D=0 -DgcdENABLE_VG=0 -DgcdUSE_VX=1 -DUSE_VDK=1 -DgcdMOVG=0 -DEGL_API_FB -DgcdSTATIC_LINK=0 -DgcdFPGA_BUILD=0 -DGC_ENABLE_LOADTIME_OPT=1 -DgcdUSE_VXC_BINARY=0 -DgcdGC355_MEM_PRINT=0 -DgcdGC355_PROFILER=0 -DVIVANTE_PROFILER=1 -DVIVANTE_PROFILER_CONTEXT=1 "

#export conf_option="  "


# Note that you must use libjpeg.a file for the vnn_pre_process step.
export my_header="-I${header_dir}/linux_sdk/linux_sdk/build/sdk/include -I${header_dir}/linux_sdk/linux_sdk/build/sdk/include/HAL -I${header_dir}/linux_sdk/linux_sdk/sdk/inc  -I./ -I${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/include/utils -I${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/include/client  -I${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/include/ops -I${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/include -I${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/third-party/jpeg-9b"

export my_lib="-Wl,-rpath-link ${header_dir}/linux_sdk/linux_sdk/build/sdk/drivers -L${header_dir}/linux_sdk/linux_sdk/build/sdk/drivers -l OpenVX -l OpenVXU -l CLC -l VSC -lGAL -L${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/lib  -lGAL ${header_dir}/linux_sdk/linux_sdk/acuity-ovxlib-dev/lib/libjpeg.a -l ovxlib -lm -lrt"

echo -e "Generating object files..."
# $compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_pre_process.o vnn_pre_process.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_inceptionv3.o vnn_inceptionv3.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/main.o main.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_pre_process.o vnn_pre_process.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_post_process.o vnn_post_process.c


if [[ $shared -eq 1 ]]; then
    echo -e "Generating the libinceptionv3.so file..."
    $compiler $shared_set $comple_flag  bin_r/vnn_inceptionv3.o  bin_r/main.o  bin_r/vnn_post_process.o bin_r/vnn_pre_process.o -o bin_r/libinceptionv3.so $my_lib
    
    echo -e "Generating the filter_nodlopen file..."
    $compiler $conf_option $my_header $comple_flag -o bin_r/filter_nodlopen filter_nodlopen.c -L./bin_r/ -linceptionv3 $my_lib
    
    echo -e "Generating the filter_dlopen file..."
    $compiler $conf_option $my_header $comple_flag -o bin_r/filter_dlopen   filter_dlopen.c   -L./bin_r/ -linceptionv3 $my_lib -ldl
else
    echo -e "Generating the inceptionv3 ELF file..."
    # Note that you must use libjpeg.a file for the vnn_pre_process step.
     $compiler $shared_set $comple_flag bin_r/vnn_inceptionv3.o  bin_r/main.o  bin_r/vnn_post_process.o -o bin_r/inceptionv3 $my_lib
fi


ls -al ./bin_r/

