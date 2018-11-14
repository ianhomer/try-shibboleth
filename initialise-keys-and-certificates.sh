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

# IDP SAML certificates
# See https://wiki.shibboleth.net/confluence/display/CONCEPT/SAMLKeysAndCertificates for more details

if [ ! -f $SHIBBOLETH_CERTS_DIR/idp-test-signing.crt ] ; then
  openssl genrsa -out $SHIBBOLETH_SECRETS_DIR/idp-test-signing.key 2048
  openssl req -new -x509 -key $SHIBBOLETH_SECRETS_DIR/idp-test-signing.key -out $SHIBBOLETH_CERTS_DIR/idp-test-signing.crt
fi

if [ ! -f $SHIBBOLETH_CERTS_DIR/idp-test-encryption.crt ] ; then
  openssl genrsa -out $SHIBBOLETH_SECRETS_DIR/idp-test-encryption.key 2048
  openssl req -new -x509 -key $SHIBBOLETH_SECRETS_DIR/idp-test-encryption.key -out $SHIBBOLETH_CERTS_DIR/idp-test-encryption.crt
fi

# SP SAML certificates

if [ ! -f $SHIBBOLETH_CERTS_DIR/sp-test.crt ] ; then
  openssl genrsa -out $SHIBBOLETH_SECRETS_DIR/sp-test.key 2048
  openssl req -new -x509 -key $SHIBBOLETH_SECRETS_DIR/sp-test.key -out $SHIBBOLETH_CERTS_DIR/sp-test.crt
fi


if [ ! -f $SHIBBOLETH_CERTS_DIR/sp-test-2.crt ] ; then
  openssl genrsa -out $SHIBBOLETH_SECRETS_DIR/sp-test-2.key 2048
  openssl req -new -x509 -key $SHIBBOLETH_SECRETS_DIR/sp-test-2.key -out $SHIBBOLETH_CERTS_DIR/sp-test-2.crt
fi

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
