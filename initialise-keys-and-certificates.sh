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
    mkdir -p $1/keys
    mkdir -p $1/certs
    openssl genrsa -out $1/keys/$2.key 2048
    subject="/C=EN/CN=localhost"
    openssl req -new -x509 -subj "${subject}" -key $1/keys/$2.key -out ${certificate} && \
      echo "... created : ${certificate}"
  else
    echo "exists  : ${certificate}"
    openssl x509 -in ${certificate} -text -noout | grep "Subject:"
  fi
  echo
}

# IDP SAML certificates
# See https://wiki.shibboleth.net/confluence/display/CONCEPT/SAMLKeysAndCertificates for more details

createKeyAndCertificate "apache/build/config/shibboleth" "idp-test-signing"
createKeyAndCertificate "apache/build/config/shibboleth" "idp-test-encryption"

# SP SAML certificates

createKeyAndCertificate "apache/build/config/shibboleth" "sp-test"
createKeyAndCertificate "apache/build/config/shibboleth" "sp-test-2"

# Apache proxy certificates

createKeyAndCertificate "apache/build/config/apache" "sp-test-proxy"
createKeyAndCertificate "apache/build/config/apache" "sp-test-proxy-ca"