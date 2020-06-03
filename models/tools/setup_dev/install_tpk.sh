#!/usr/bin/env bash

_tpk_file="./sec.odl.imageclassification-1.0.0-arm.tpk"
pkgcmd -i -t tpk -p ./$_tpk_file
app_launcher  -s sec.odl.imageclassification
ps -ef | grep sec.odl

