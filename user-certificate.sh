#!/bin/bash

# create user key
# presumes standard directory of strongswan 

VPN_COUNTRY=""
VPN_IP_ADDRESS=""
VPN_NAME=""

echo "Entering strongswan config directory..."
cd /etc/strongswan/ipsec.d/

echo -n "Enter a username: "
read USR_NAME

echo -n "Enter an email (identity): "
read IDENTITY

strongswan pki --gen --type rsa --size 2048 \
	--outform pem \
	> private/${USR_NAME}Key.pem
chmod 600 private/${USR_NAME}Key.pem
strongswan pki --pub --in private/${USR_NAME}Key.pem --type rsa | \
	strongswan pki --issue --lifetime 730 \
	--cacert cacerts/strongswanCert.pem \
	--cakey private/strongswanKey.pem \
	--dn "C=$VPN_COUNTRY, O=$VPN_NAME, CN=$IDENTITY" \
	--san $IDENTITY \
	--outform pem > certs/${USR_NAME}Cert.pem

echo "Exporting to a PKCS12 file..."

openssl pkcs12 -export -inkey private/${USR_NAME}Key.pem \
	-in certs/${USR_NAME}Cert.pem -name "${USR_NAME}'s Certifcate" \
	-certfile cacerts/strongswanCert.pem \
	-caname "$VPN_NAME" \
	-out $USR_NAME.p12
