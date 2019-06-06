#!/bin/bash

# create self-signed CA certificate
# presumes standard directory of strongswan 

VPN_COUNTRY=""
VPN_IP_ADDRESS=""
VPN_NAME=""


echo "Entering strongswan config directory..."
cd /etc/strongswan/ipsec.d/
strongswan pki --gen --type rsa --size 4096 --outform pem \
	> private/strongswanKey.pem
chmod 600 private/strongswanKey.pem
strongswan pki --self --ca --lifetime 3650 \
	--in private/strongswanKey.pem --type rsa \
	--dn "C=$VPN_COUNTRY, O=$VPN_NAME, CN=$VPN_IP_ADDRESS" \
	--outform pem \
	> cacerts/strongswanCert.pem
