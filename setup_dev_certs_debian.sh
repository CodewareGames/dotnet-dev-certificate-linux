#!/bin/bash

ASPNET=/usr/.aspnet/https

sudo rm -rf $ASPNET
sudo mkdir -p $ASPNET

echo -e "\n\n#### Generating self-signed certificate authority ####"
sudo openssl genrsa -out $ASPNET/ca.key 4096
sudo openssl req -x509 -new -nodes -key $ASPNET/ca.key -sha256 -days 730 -out $ASPNET/ca.crt -config ca.conf

echo -e "\n\n#### Generating server certificate and signing it ####"
sudo openssl genrsa -out $ASPNET/localhost.key 4096
sudo openssl req -new -key $ASPNET/localhost.key -out $ASPNET/localhost.csr -config localhost.conf
sudo openssl req -text -noout -verify -in $ASPNET/localhost.csr
sudo openssl x509 -req -in $ASPNET/localhost.csr -CA $ASPNET/ca.crt -CAkey $ASPNET/ca.key -CAcreateserial -out $ASPNET/localhost.crt -days 730 -sha256 -extfile localhost.conf -extensions v3_req

echo -e "\n\n#### Verify certificate ####"
sudo openssl verify -CAfile $ASPNET/ca.crt $ASPNET/localhost.crt

echo -e "\n\n#### Convert certificate to pfx ####"
sudo openssl pkcs12 -export -out $ASPNET/localhost.pfx -inkey $ASPNET/localhost.key -in $ASPNET/localhost.crt --passout pass:

echo -e "\n\n#### Copying Developer Root CA certificate to Trust Store ####"
sudo rm -rf /usr/local/share/ca-certificates/aspnet
sudo mkdir -p /usr/local/share/ca-certificates/aspnet
sudo cp $ASPNET/ca.crt /usr/local/share/ca-certificates/aspnet/ca.crt
sudo update-ca-certificates

echo -e "\n\n#### Verify that server certificate is trusted by system ####"
sudo openssl verify $ASPNET/localhost.crt

echo -e "\n\n#### Trusting self-signed server certificate in dotnet ####"
sudo rm -rf "$HOME"/.dotnet/corefx/cryptography/x509stores/my/*
sudo dotnet dev-certs https --clean --import $ASPNET/localhost.pfx -p ""

echo -e "\n\n#### Adding Policy to Local Firefox ####"
echo "{
    \"policies\": {
        \"Certificates\": {
            \"ImportEnterpriseRoots\": true,
            \"Install\": [
            	\"$ASPNET/ca.crt\"
            ]
        }
    }
}" > policies.json
sudo mkdir -p /usr/lib/firefox/distribution/
sudo mv policies.json /usr/lib/firefox/distribution/
echo -e "done."

echo -e "\n\n#### Trusting self-signed Developer Root CA certificate in browsers ####"
sudo apt install libnss3-tools

certfile="${ASPNET}/ca.crt"
certname="localhost"

for certDB in $(find ~/ -name "cert8.db")
do
	certdir=$(dirname ${certDB});
	certutil -A -n "${certname}" -t "C,," -i ${certfile} -d dbm:${certdir}
	echo "Adding ${certname} to ${certdir}"
done

for certDB in $(find ~/ -name "cert9.db")
do
	certdir=$(dirname ${certDB});
	certutil -A -n "${certname}" -t "C,," -i ${certfile} -d sql:${certdir}
	echo "Adding ${certname} to ${certdir}"
done
