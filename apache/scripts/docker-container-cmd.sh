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
  file=$1
  shift
  #
  # Loop through all place holders and replace the value in the file
  #
  for name in "$@" ; do
    echo "${file} : placeholder replace - ${name}:"
    value=`eval echo \\$$name`
    if [ -z "$value" ] ; then
      name_FILE="${name}_FILE"
      variable_file=`eval echo \\$$name_FILE`
      echo "file containing variable ${name} : ${variable_file}"
      if [ -z ${variable_file} ] ; then
        value="please-set-$name"
      else
        #
        # If environmental variable not provided and we have a file name defined, then read the file into this
        # variable.
        #
        if [ -f ${variable_file} ] ; then
          value=$(readCertificateFile ${variable_file})
        else
          value="please set ${name} or provide ${variable_file}"
        fi
      fi
    fi
    #
    # Special case, if value is set to __EMPTY__ then value is the empty string
    #
    if [ "${value}" = "__EMPTY__" ] ; then
      value=""
    fi
    echo ${value}
    sed -i "s#\${$name}#${value}#g" ${file}
  done
}

#
# Create string that can be appended after domain to specific port (if it's not default port)
#
createPortPostfix() {
  if [ "$2" = "https" -a "$1" != "443" ] ; then
    echo ":${1}"
  elif [ "$2" = "http" -a "$1" != "80" ] ; then
    echo ":${1}"
  else
    echo "__EMPTY__"
  fi
}

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
replacePlaceholders /etc/shibboleth/metadata/idp.xml IDP_PROTOCOL IDP_DOMAIN IDP_PORT_POSTFIX IDP_HTTP_REDIRECT_PATH IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE
replacePlaceholders /etc/shibboleth/metadata/sp.xml SP_PROTOCOL SP_DOMAIN SP_PORT_POSTFIX SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE

# Copy IDP / SP entity descriptors into place
if [ -d /config/shibboleth/metadata ] ; then
  cp /config/shibboleth/metadata/*.xml /etc/shibboleth/metadata
fi
echo "SP/IDP entity descriptor metadata"
ls /etc/shibboleth/metadata/*.xml

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground