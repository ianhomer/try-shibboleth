#!/bin/sh

#
# Mac specific versions of functions
#

#
# Read the given certificate file into output
#
readCertificateFile() {
  echo "(certificate - $1)"
  # Note that this mac version of this command is not valid, but does enough to help
  # validate the rest of the script.
  sed '/^-----/d' $1
  #sed '/^-----/d' $1 | sed '{:q;N;s/\n/\\n/g;t q}'
}

#
# Replace a single place holder
#
replacePlaceholder() {
  if [ -z "${3}" ] ; then
    echo "No file to replace passed in for $1 -> $2"
  else
    sed -i '' "s#\${$1}#${2}#g" ${3}
  fi
}