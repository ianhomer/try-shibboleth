#!/bin/sh

echo "Initialising keys and certificates"

export SHIBBOLETH_SECRETS_DIR=apache/build/config/shibboleth/keys
mkdir -p $SHIBBOLETH_SECRETS_DIR
export SHIBBOLETH_CERTS_DIR=apache/build/config/shibboleth/certs
mkdir -p $SHIBBOLETH_CERTS_DIR
export APACHE_SECRETS_DIR=apache/build/config/apache/keys
mkdir -p $APACHE_SECRETS_DIR
export APACHE_CERTS_DIR=apache/build/config/apache/certs
mkdir -p $APACHE_CERTS_DIR

createKeyAndCertificate() {
  certificate=$1/certs/$2.crt
  if [ ! -f ${certificate} ] ; then
    properties=$1/certs/$2.properties
    echo "creating   : ${certificate}"
    echo > ${properties} << EOF
distinguished_name=cn=localhost
countryName=en
EOF

    mkdir -p $1/keys
    mkdir -p $1/certs
    openssl genrsa -out $1/keys/$2.key 2048
    openssl req -new -x509 -batch -config ${properties} -key $1/keys/$2.key -out ${certificate} && \
      echo "... created : ${certificate}"
  else
    echo "exists  : ${certificate}"
  fi
}

# IDP SAML certificates
# See https://wiki.shibboleth.net/confluence/display/CONCEPT/SAMLKeysAndCertificates for more details

createKeyAndCertificate "apache/build/config/shibboleth" "idp-test-signing"
createKeyAndCertificate "apache/build/config/shibboleth" "idp-test-encryption"

# SP SAML certificates

createKeyAndCertificate "apache/build/config/shibboleth" "sp-test"
createKeyAndCertificate "apache/build/config/shibboleth" "sp-test-2"

# Apache proxy certificates

if [ ! -f $APACHE_CERTS_DIR/sp-test-proxy.crt ] ; then
  openssl genrsa -out $APACHE_SECRETS_DIR/sp-test-proxy.key 2048
  echo "MUST : enter localhost as common name"
  openssl req -new -x509 -key $APACHE_SECRETS_DIR/sp-test-proxy.key -out $APACHE_CERTS_DIR/sp-test-proxy.crt
fi

if [ ! -f $APACHE_CERTS_DIR/sp-test-proxy-ca.crt ] ; then
  openssl genrsa -out $APACHE_SECRETS_DIR/sp-proxy-ca.key 2048
  openssl req -new -x509 -key $APACHE_SECRETS_DIR/sp-test-proxy.key -out $APACHE_CERTS_DIR/sp-test-proxy-ca.crt
fi
