#!/bin/sh

#
# Read the given certificate file into output
#
readCertificateFile() {
  sed '/^-----/d' $1 | sed '{:q;N;s/\n/\\n/g;t q}'
}

#
# Replace a single place holder

replacePlaceholder() {
  sed -i "s#\${$1}#${2}#g" ${3}
}