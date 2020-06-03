#!/usr/bin/env bash

## @brief The simple build script for Tizen 6.0 platform
#  @Author Geunsik Lim <geunsik.lim@samsung.com>
#
#  @note
#   Build source code on Tizen 6.0 ARM 32bit on RPi board (Vivante)
#   - tizen# zypper install binutils gcc libgcc gcc-c++ cpp
#   - tizen# zypper install amlogic-vsi-npu-sdk-devel
#   - tizen# zypper install acuity-ovxlib-devel
#   - tizen# ./mybuild-tizen.sh


# ---------------------- Initialization area -------------------------------------
rm -rf ./bin_r/
mkdir  ./bin_r/

# ---------------------- configuration area -------------------------------------
shared=1

# ---------------------- build area -----------------------------------------------
# Handle one between Ubuntu/ARM and Tizen/ARM
export header_dir="/usr/include"
export compiler="gcc -g"
export compile_flag=""

# Handle one between dynaming linking and static linking (ELF).
if [[ $shared -eq 1 ]]; then
    export pic_set="-fPIC"
    export shared_set="-shared"
else
    export pic_set=" "
    export shared_set=" "
fi

export conf_option=" "
export my_header="-I/usr/include/dann -I/usr/include/ovx -I/usr/include/amlogic-vsi-npu-sdk "
export my_lib="-lOpenVX -lOpenVXU -lCLC -lVSC -lGAL -lGAL -lovxlib -lm -lrt -ljpeg"

echo -e "Generating object files..."
$compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_inceptionv3.o vnn_inceptionv3.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/main.o main.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_pre_process.o vnn_pre_process.c
$compiler -c $conf_option $my_header $pic_set -o bin_r/vnn_post_process.o vnn_post_process.c

if [[ $shared -eq 1 ]]; then
    echo -e "Generating the libinceptionv3.so file..."
    $compiler $pic_set $shared_set $compile_flag  bin_r/vnn_inceptionv3.o  bin_r/main.o  bin_r/vnn_post_process.o bin_r/vnn_pre_process.o -o bin_r/libinceptionv3.so $my_lib
    
    echo -e "Generating the [filter_nodlopen] ELF file..."
    $compiler $conf_option $my_header $compile_flag -o bin_r/filter_nodlopen filter_nodlopen.c -L./bin_r/ -linceptionv3 $my_lib
    pushd ./bin_r ; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./ ; ./filter_nodlopen ../bin_demo_deprecated/inception_v3.nb ../bin_demo_deprecated/goldfish_299x299.jpg  ; popd
    
    echo -e "------------------------------------------"
    echo -e "Generating the [filter_dlopen] ELF file..."
    $compiler $conf_option $my_header $compile_flag -o bin_r/filter_dlopen   filter_dlopen.c   -L./bin_r/ -linceptionv3 $my_lib -ldl
    pushd ./bin_r ; ./filter_dlopen ../bin_demo_deprecated/inception_v3.nb ../bin_demo_deprecated/goldfish_299x299.jpg  ; popd
else
    echo -e "Generating the inceptionv3 ELF file..."
    echo -e "Note that you must use the libjpeg library file for the vnn_pre_process step."
    $compiler $shared_set $compile_flag bin_r/vnn_inceptionv3.o  bin_r/main.o  bin_r/vnn_pre_process.o bin_r/vnn_post_process.o -o bin_r/inceptionv3 $my_lib

    echo -e "Run the ELF files"
    pushd ./bin_r ; ./inceptionv3 ../bin_demo_deprecated/inception_v3.nb ../bin_demo_deprecated/goldfish_299x299.jpg ; popd 
fi

echo -e "The generated files are follows."
ls -al ./bin_r/


# copy .so to the /usr/share/vivante/ folder.
so_file="./bin_r/libinceptionv3.so"
lib_dir="/usr/share/vivante/inceptionv3/"

if [[ -f $so_file ]]; then
    mkdir $lib_dir
    cp $so_file  $lib_dir
    echo -e "Success. '$so_file' is copied to $lib_dir folder."
else
    echo -e "Failure. The '$so_file' is not built. Please fix source file correctly." 
    exit 1
fi

exit 0
