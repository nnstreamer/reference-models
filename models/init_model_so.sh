#!/usr/bin/env bash

# The code initializer to re-organize the existing case code
# for the Vivante tensor filter.

if [[ ! "$1"  ]]; then
    echo -e "Usage: $ $0 {folder_name}"
    exit 1
fi

$_folder_name="$1"


echo -e "Installing required packages ..."
if [[ $(which zypper) ]]; then
    zypper install binutils gcc libgcc gcc-c++
    zypper install amlogic-vsi-npu-sdk-devel
else
    echo -e "You need to install the 'zypper' package."
    exit 1
fi


#----------------- DO NOTE MODIFY FROM THIS LINE ------------------
echo -e "Initializing the required files..."
cp ./tools/build-strap/main.h ./$1/
cp ./tools/build-strap/mybuild-tizen.sh ./$1/

pushd ./$1/
echo -e "Removing 'static' from the functions in a main.c file..."
find . -type f -name '*' -exec perl -pi -e 's/static//g' {} \;


echo -e "Building the source files..."
./mybuild-tizen.sh
if [[ $? == 0 ]]; then
   echo -e "Success. The task is successfully completed."
else
   echo -e "Failure. The task is not completed. Please contact a maintainer."
fi

popd
