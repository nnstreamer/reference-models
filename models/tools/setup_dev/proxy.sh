#!/usr/bin/env bash

# If your network IP address is based on the company firewall,
# please specifity a proxy address.

echo '# Proxy setting' >> /etc/profile
echo 'export http_proxy="http://10.112.xxx.xxx:8080/"' >> /etc/profile
echo 'export https_proxy="http://10.112.xxx.xxx:8080/"' >> /etc/profile
echo 'export no_proxy="localhost,127.0.0.1"' >> /etc/profile

source /etc/profile

echo 'The proxy information is added into /etc/profile file.'
