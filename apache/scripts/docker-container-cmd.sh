#!/bin/sh

env

: "${IDP_DOMAIN:=please-set-idp-domain}"
: "${IDP_SIGNING_CERTIFICATE:=please-set-idp-signing-certificate}"
: "${IDP_ENCRYPTION_CERTIFICATE:=please-set-idp-encryption-certificate}"

: "${SP_DOMAIN:=localhost}"
: "${SP_CERTIFICATE_SUBJECT_NAME:=CN=localhost,O=organisation,L=location,ST=state,C=GB}"
: "${SP_CERTIFICATE:=please-set-sp-certificate}"

replacePlaceholders() {
  filename=$1
  shift
  for name in "$@" ; do
    echo "$filename : placeholder replace - $name  "
    value=`eval echo \\$$name`
    sed -i "s#\${$name}#${value}#g" $filename
  done
}

replacePlaceholders /etc/shibboleth/metadata.xml SP_DOMAIN SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE
replacePlaceholders /etc/shibboleth/metadata.xml IDP_DOMAIN IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground