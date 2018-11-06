#!/bin/sh

env

. shibboleth-setup-functions.sh

LOCAL_CONFIG_DIR=/config/shibboleth

: "${IDP_PROTOCOL:=https}"
: "${IDP_PORT:=443}"
: "${IDP_SIGNING_CERTIFICATE_FILE:=/config/shibboleth/idp-signing.crt}"
: "${IDP_ENCRYPTION_CERTIFICATE_FILE:=/config/shibboleth/idp-encryption.crt}"
: "${IDP_HTTP_REDIRECT_PATH:=/idp/profile/SAML2/Redirect/SSO}"

: "${SP_DOMAIN:=localhost}"
: "${SP_PORT:=443}"
: "${SP_PROTOCOL:=https}"
: "${SP_CERTIFICATE_FILE:=/config/shibboleth/sp.crt}"
: "${SP_CERTIFICATE_SUBJECT_NAME:=CN=localhost,O=organisation,L=location,ST=state,C=GB}"

IDP_PORT_POSTFIX=$(createPortPostfix ${IDP_PORT} ${IDP_PROTOCOL})
SP_PORT_POSTFIX=$(createPortPostfix ${SP_PORT} ${SP_PROTOCOL})

replacePlaceholders /etc/shibboleth/shibboleth2.xml IDP_DOMAIN IDP_PORT_POSTFIX SP_PROTOCOL SP_DOMAIN

# Template single IDP / SP mode
replacePlaceholders /etc/shibboleth/metadata/idp.xml IDP_PROTOCOL IDP_DOMAIN IDP_PORT_POSTFIX IDP_HTTP_REDIRECT_PATH IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE
replacePlaceholders /etc/shibboleth/metadata/sp.xml SP_PROTOCOL SP_DOMAIN SP_PORT_POSTFIX SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE

# Template IDP / SP entity properties
createEntitiesFromProperties

# Copy explicit IDP / SP entity descriptors into place
if [ -d ${LOCAL_CONFIG_DIR}/metadata ] ; then
  cp ${LOCAL_CONFIG_DIR}/metadata/*.xml /etc/shibboleth/metadata
fi
echo << EOF

Summary
-------
SP/IDP entity descriptor metadata
EOF

ls /etc/shibboleth/metadata/*.xml

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground