#!/bin/sh

env

: "${IDP_DOMAIN:=please-set-IDP_DOMAIN}"
: "${IDP_SIGNING_CERTIFICATE:=please-set-IDP_SIGNING_CERTIFICATE}"
: "${IDP_ENCRYPTION_CERTIFICATE:=please-set-IDP_ENCRYPTION_CERTIFICATE}"

: "${SP_DOMAIN:=localhost}"
: "${SP_CERTIFICATE_SUBJECT_NAME:=CN=localhost,O=organisation,L=location,ST=state,C=GB}"
: "${SP_CERTIFICATE:=please-set-SP_CERTIFICATE}"

replacePlaceholders() {
  filename=$1
  shift
  for name in "$@" ; do
    echo "$filename : placeholder replace - $name  "
    value=`eval echo \\$$name`
    sed -i "s#\${$name}#${value}#g" $filename
  done
}

replacePlaceholders /etc/shibboleth/metadata/sp.xml SP_DOMAIN SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE
replacePlaceholders /etc/shibboleth/shibboleth2.xml IDP_DOMAIN
replacePlaceholders /etc/shibboleth/metadata/idp.xml IDP_DOMAIN IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground