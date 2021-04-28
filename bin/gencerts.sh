#!/bin/sh

mkdir certs

CA_ORG="/O=IoT Management/emailAddress=admin@example.com"
CA_DN="/CN=mqtt${CA_ORG}"
MQTT_DN="/CN=mqtt$CA_ORG"
TWIN_DN="/CN=mqtt$CA_ORG"

# Certificate authority
openssl req -newkey rsa:2048 -x509 -nodes -sha512 -days 3650 -extensions v3_ca -keyout certs/ca.key -out certs/ca.crt -subj "${CA_DN}"


# MQTT broker certificate
openssl genrsa -out certs/mqtt.key 2048
openssl req -new -sha512 -out certs/mqtt.csr -key certs/mqtt.key -subj "${MQTT_DN}"

cat > "certs/mqtt.cnf" << EOF
[v3_req]
basicConstraints        = critical,CA:FALSE
nsCertType              = server
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
keyUsage                = nonRepudiation, digitalSignature, keyEncipherment
EOF
openssl x509 -req -sha512 -in certs/mqtt.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -CAserial certs/ca.srl -out certs/mqtt.crt -days 365 -extfile "certs/mqtt.cnf" -extensions v3_req


# Device twin certificate
openssl genrsa -out certs/devicetwin.key 2048
openssl req -new -sha512 -out certs/devicetwin.csr -key certs/devicetwin.key -subj "${TWIN_DN}"

cat > "certs/devicetwin.cnf" << EOF
[v3_req]
basicConstraints        = critical,CA:FALSE
nsCertType              = client
extendedKeyUsage        = clientAuth
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
keyUsage                = digitalSignature, keyEncipherment, keyAgreement
EOF
openssl x509 -req -sha512 -in certs/devicetwin.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -CAserial certs/ca.srl -out certs/devicetwin.crt -days 365 -extfile "certs/devicetwin.cnf" -extensions v3_req

# Clean up
rm -rf certs/*.cnf certs/*.csr

