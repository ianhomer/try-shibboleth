#!/bin/sh

if [ `uname` = 'Darwin' ] ; then
  . shibboleth-setup-commons-mac.sh
else
  . shibboleth-setup-commons.sh
fi

. shibboleth-setup-functions.sh
