#!/bin/bash

# create host key signed by CA
# presumes standard directory of strongswan 

VPN_COUNTRY=""
VPN_IP_ADDRESS=""
VPN_NAME=""

echo "Entering strongswan config directory..."
cd /etc/strongswan/ipsec.d/
strongswan pki --gen --type rsa --size 2048 \
	--outform pem \
	> private/vpnHostKey.pem
chmod 600 private/vpnHostKey.pem
strongswan pki --pub --in private/vpnHostKey.pem --type rsa | \
	strongswan pki --issue --lifetime 730 \
	--cacert cacerts/strongswanCert.pem \
	--cakey private/strongswanKey.pem \
	--dn "C=$VPN_COUNTRY, O=$VPN_NAME, CN=$VPN_IP_ADDRESS" \
	--san $VPN_IP_ADDRESS \
	--flag serverAuth --flag ikeIntermediate \
	--outform pem > certs/vpnHostCert.pem
