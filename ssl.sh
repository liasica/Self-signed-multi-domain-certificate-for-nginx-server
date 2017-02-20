#!/bin/bash
#
# thx for http://www.cnblogs.com/liqingjht/p/6267563.html
echo "Generating an SSL private key to sign your certificate..."
openssl genrsa -des3 -out server.key 2048

echo "Generating a Certificate Signing Request..."
openssl req -new -key server.key -out server.csr -config ./openssl.cnf

echo "Removing passphrase from key (for nginx)..."
cp server.key server.key.org
openssl rsa -in server.key.org -out server.key
rm server.key.org

echo "Generating CA..."
mkdir ./newcerts
touch index.txt
echo 01 > serial
openssl req -new -x509 -days 3650 -keyout ca.key -out ca.crt -config ./openssl.cnf

echo "Generating certificate..."
openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key -extensions v3_req -config openssl.cnf

echo "Copying certificate (server.crt) to /usr/local/etc/nginx/ssl/"
mkdir -p /usr/local/etc/nginx/ssl/
rm -rf /usr/local/etc/nginx/ssl/server.crt
cp -f server.crt /usr/local/etc/nginx/ssl/

echo "Copying key (server.key) to /usr/local/etc/nginx/ssl/"
mkdir -p /usr/local/etc/nginx/ssl/
rm -rf /usr/local/etc/nginx/ssl/server.key
cp server.key /usr/local/etc/nginx/ssl/
