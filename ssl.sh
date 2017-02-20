#!/bin/bash
#
# thx for http://www.cnblogs.com/liqingjht/p/6267563.html
mkdir cert
echo "Generating an SSL private key to sign your certificate..."
openssl genrsa -des3 -out cert/server.key 2048

echo "Generating a Certificate Signing Request..."
openssl req -new -key cert/server.key -out cert/server.csr -config ./openssl.cnf

echo "Removing passphrase from key (for nginx)..."
cp cert/server.key cert/server.key.org
openssl rsa -in cert/server.key.org -out cert/server.key
rm cert/server.key.org

echo "Generating CA..."
touch cert/index.txt
echo 01 > cert/serial
openssl req -new -x509 -days 3650 -keyout cert/ca.key -out cert/ca.crt -config openssl.cnf

echo "Generating certificate..."
openssl ca -in cert/server.csr -out cert/server.crt -cert cert/ca.crt -keyfile cert/ca.key -extensions v3_req -config openssl.cnf

echo "Copying certificate (cert/server.crt) to /usr/local/etc/nginx/ssl/"
mkdir -p /usr/local/etc/nginx/ssl/
rm -rf /usr/local/etc/nginx/ssl/cert/server.crt
cp -f cert/server.crt /usr/local/etc/nginx/ssl/

echo "Copying key (cert/server.key) to /usr/local/etc/nginx/ssl/"
mkdir -p /usr/local/etc/nginx/ssl/
rm -rf /usr/local/etc/nginx/ssl/cert/server.key
cp cert/server.key /usr/local/etc/nginx/ssl/
