#!/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
  echo -e "\033[31mThis script must be run as root.\033[0m"
  exit 1
fi

UBUNTU_VERSION=$(cat /etc/issue | awk '{print $2}')
MAJOR_VERSION=$(echo "$UBUNTU_VERSION" | awk -F'.' '{print $1}')

if [ "$MAJOR_VERSION" -ge 22 ]; then
  echo -e "\033[32mUbuntu version is 22.04 or higher.\033[0m"
else
  echo -e "\033[31mUbuntu version is less than 22.04.\033[0m"
  exit 1
fi

wget https://www.openssl.org/source/openssl-3.0.8.tar.gz
tar -xvf openssl-3.0.8.tar.gz
cd openssl-3.0.8
./config -DOPENSSL_TLS_SECURITY_LEVEL=0
make
make install

apt remove libssl-dev -y

apt install --reinstall nginx -y

systemctl restart nginx
systemctl reload nginx



# config for the virtualhost
# source: https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=old&openssl=3.0.8&hsts=false&ocsp=false&guideline=5.6
# should go in 000-catch-all and virtualhost
#ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
#ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA;
#ssl_prefer_server_ciphers on;
