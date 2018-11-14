# Create keys and certificates

    export SECRET_DIR=$HOME/.config/secret
    mkdir -p $SECRET_DIR
    export CERT_DIR=$HOME/.config/certs
    mkdir -p $CERT_DIR

# IDP SAML certificates

    openssl genrsa -out $SECRET_DIR/idp-test-signing.key 2048
    openssl req -new -x509 -key $SECRET_DIR/idp-test-signing.key -out $CERT_DIR/idp-test-signing.crt

    openssl genrsa -out $SECRET_DIR/idp-test-encryption.key 2048
    openssl req -new -x509 -key $SECRET_DIR/idp-test-encryption.key -out $CERT_DIR/idp-test-encryption.crt
    
See https://wiki.shibboleth.net/confluence/display/CONCEPT/SAMLKeysAndCertificates for more details
    
# SP SAML certificates

    openssl genrsa -out $SECRET_DIR/sp-test.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp-test.key -out $CERT_DIR/sp-test.crt

    openssl genrsa -out $SECRET_DIR/sp-test-2.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp-test-2.key -out $CERT_DIR/sp-test-2.crt

# Apache proxy certificates

    openssl genrsa -out $SECRET_DIR/sp-test-proxy.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp-test-proxy.key -out $CERT_DIR/sp-test-proxy.crt

    openssl genrsa -out $SECRET_DIR/sp-proxy-ca.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp-test-proxy.key -out $CERT_DIR/sp-test-proxy-ca.crt
