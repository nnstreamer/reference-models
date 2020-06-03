#!/usr/bin/env bash

ifconfig eth0 10.113.221.123 netmask 255.255.255.0 up
route add default gw 10.113.221.1

