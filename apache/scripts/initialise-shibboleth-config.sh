#!/bin/sh

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

replacePlaceholders ${SHIBBOLETH_CONF_DIR}/shibboleth2.xml IDP_DOMAIN IDP_PORT_POSTFIX SP_PROTOCOL SP_DOMAIN

# Template single IDP / SP mode
replacePlaceholders ${SHIBBOLETH_CONF_DIR}/metadata/idp.xml IDP_PROTOCOL IDP_DOMAIN IDP_PORT_POSTFIX IDP_HTTP_REDIRECT_PATH IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE
replacePlaceholders ${SHIBBOLETH_CONF_DIR}/metadata/sp.xml SP_PROTOCOL SP_DOMAIN SP_PORT_POSTFIX SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE

# Template IDP / SP entity properties
createEntitiesFromProperties

# Copy explicit IDP / SP entity descriptors into place
if [ -d ${LOCAL_CONFIG_DIR}/metadata ] ; then
  cp ${LOCAL_CONFIG_DIR}/metadata/*.xml ${SHIBBOLETH_CONF_DIR}/metadata
fi
echo << EOF

Summary
-------
SP/IDP entity descriptor metadata
EOF


ls ${SHIBBOLETH_CONF_DIR}/metadata/*.xml