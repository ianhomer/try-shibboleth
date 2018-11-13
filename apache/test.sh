#!/bin/sh

echo "Testing configuration scripts"

mkdir -p target/config/shibboleth
mkdir -p target/etc/shibbolet

cp -R config/shibboleth/ target/config/shibboleth
cp -R build/config/shibboleth/ target/config/shibboleth
cp -R scripts/ target/scripts
cp -R shibboleth/ target/etc/shibboleth

export SHIBBOLETH_CONF_DIR=`pwd`/target/etc/shibboleth
export LOCAL_CONFIG_DIR=`pwd`/target/config/shibboleth

cd target/scripts

. shibboleth-setup-loader.sh
. initialise-shibboleth-config.sh