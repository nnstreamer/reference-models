#!/usr/bin/env bash

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./

# gst-launch-1.0 --gst-plugin-path=${PATH_TO_PLUGIN} videotestsrc ! videoconvert ! videoscale ! video/x-raw,format=RGB,width=299,height=299 !  tensor_converter ! tensor_filter framework=vivante model="./bin_demo/inception_v3.nb,./bin_r/libinceptionv3.so" ! filesink location=vivante.out.bin

gst-launch-1.0 --gst-plugin-path=${PATH_TO_PLUGIN} filesrc location=./dog_299x299.jpg ! jpegdec !  videoconvert  ! video/x-raw,format=RGB,width=299,height=299 ! tensor_converter ! tensor_filter framework=vivante model="./inception_v3.nb,./libinceptionv3.so" ! filesink location=vivante.out.bin
 
