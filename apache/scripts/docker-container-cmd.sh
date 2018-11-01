#!/bin/sh

env

#
# Read the given certificate file into a variable
#
readCertificateFile() {
  sed '/^-----/d' $1 | sed '{:q;N;s/\n/\\n/g;t q}'
}

#
# Replace place holders in the file with the given place holders
#
replacePlaceholders() {
  filename=$1
  shift
  for name in "$@" ; do
    echo "$filename : placeholder replace - $name  "
    value=`eval echo \\$$name`
    if [ -z "$value" ] ; then
      filename_name="${name}_FILE"
      filename=`eval echo \\$$filename_name`
      echo "filename $filename"
      if [ -z $filename ] ; then
        value="please-set-$name"
      else
        #
        # If environmental variable not provided and we have a file name defined, then read the file into this
        # variable.
        #
        if [ -f $filename ] ; then
          value=$(readCertificateFile $filename)
        else
          value="please set ${name} or provide ${filename}"
        fi
      fi
    fi
    echo $value
    sed -i "s#\${$name}#${value}#g" $filename
  done
}

: "${IDP_DOMAIN:=please-set-IDP_DOMAIN}"
: "${IDP_SIGNING_CERTIFICATE:=please-set-IDP_SIGNING_CERTIFICATE}"
: "${IDP_ENCRYPTION_CERTIFICATE:=please-set-IDP_ENCRYPTION_CERTIFICATE}"

: "${SP_DOMAIN:=localhost}"
: "${SP_CERTIFICATE_FILE:=/config/shibboleth/sp.cert}"
: "${SP_CERTIFICATE_SUBJECT_NAME:=CN=localhost,O=organisation,L=location,ST=state,C=GB}"


replacePlaceholders /etc/shibboleth/metadata/sp.xml SP_DOMAIN SP_CERTIFICATE_SUBJECT_NAME SP_CERTIFICATE
replacePlaceholders /etc/shibboleth/shibboleth2.xml IDP_DOMAIN
replacePlaceholders /etc/shibboleth/metadata/idp.xml IDP_DOMAIN IDP_SIGNING_CERTIFICATE IDP_ENCRYPTION_CERTIFICATE

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground