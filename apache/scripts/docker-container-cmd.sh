#!/bin/sh

env

#
# Read the given certificate file into a variable
#
readCertificateFile() {
  sed '/^-----/d' $1 | sed '{:q;N;s/\n/\\n/g;t q}'
}

#
# Replace place holders in the file with the given place holder value, either from environment variable or load from
# configuration file.
#
replacePlaceholders() {
  filename=$1
  shift
  for name in "$@" ; do
    echo "$filename : placeholder replace - ${name}:"
    value=`eval echo \\$$name`
    if [ -z "$value" ] ; then
      var_filename_name="${name}_FILE"
      var_filename=`eval echo \\$$var_filename_name`
      echo "filename $var_filename"
      if [ -z ${var_filename} ] ; then
        value="please-set-$name"
      else
        #
        # If environmental variable not provided and we have a file name defined, then read the file into this
        # variable.
        #
        if [ -f ${var_filename} ] ; then
          value=$(readCertificateFile ${var_filename})
        else
          value="please set ${name} or provide ${var_filename}"
        fi
      fi
    fi
    if [ "${value}" = "__EMPTY__" ] ; then
      value=""
    fi
    echo ${value}
    sed -i "s#\${$name}#${value}#g" $filename
  done
}

: "${IDP_PORT:=443}"
: "${IDP_SIGNING_CERTIFICATE_FILE:=/config/shibboleth/idp-signing.crt}"
: "${IDP_ENCRYPTION_CERTIFICATE_FILE:=/config/shibboleth/idp-encryption.crt}"
: "${IDP_HTTP_REDIRECT_PATH:=/idp/profile/SAML2/Redirect/SSO}"

: "${SP_DOMAIN:=localhost}"
: "${SP_PROTOCOL:=https}"
: "${SP_CERTIFICATE_FILE:=/config/shibboleth/sp.crt}"
: "${SP_CERTIFICATE_SUBJECT_NAME:=CN=localhost,O=organisation,L=location,ST=state,C=GB}"

if [ "$IDP_PORT" != "443" ] ; then
  IDP_PORT_POSTFIX=":${IDP_PORT}"
else
  IDP_PORT_POSTFIX="__EMPTY__"
fi

replacePlaceholders /etc/shibboleth/shibboleth2.xml IDP_DOMAIN IDP_PORT_POSTFIX SP_PROTOCOL SP_DOMAIN
replacePlaceholders /etc/shibboleth/metadata/idp.xml IDP_DOMAIN IDP_PORT_POSTFIX IDP_HTTP_REDIRECT_PATH IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE
replacePlaceholders /etc/shibboleth/metadata/sp.xml SP_PROTOCOL SP_DOMAIN SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE

# Copy IDP / SP entity descriptors into place
if [ -d /config/shibboleth/metadata ] ; then
  cp /config/shibboleth/metadata/*.xml /etc/shibboleth/metadata
fi
echo "SP/IDP entity descriptor metadata"
ls /etc/shibboleth/metadata/*.xml

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground