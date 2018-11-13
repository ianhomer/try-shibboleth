# Create keys and certificates

    export SECRET_DIR=$HOME/.config/secret
    mkdir -p $SECRET_DIR
    export CERT_DIR=$HOME/.config/certs
    mkdir -p $CERT_DIR

# IDP SAML certificates

    openssl genrsa -out $SECRET_DIR/idp-signing.key 2048
    openssl req -new -x509 -key $SECRET_DIR/idp-signing.key -out $CERT_DIR/idp-signing.crt

    openssl genrsa -out $SECRET_DIR/idp-encryption.key 2048
    openssl req -new -x509 -key $SECRET_DIR/idp-encryption.key -out $CERT_DIR/idp-encryption.crt
    
# SP SAML certificates

    openssl genrsa -out $SECRET_DIR/sp.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp.key -out $CERT_DIR/sp.crt

    openssl genrsa -out $SECRET_DIR/sp-2.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp-2.key -out $CERT_DIR/sp-2.crt

# Apache proxy certificates

    openssl genrsa -out $SECRET_DIR/sp-proxy.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp-proxy.key -out $CERT_DIR/sp-proxy.crt
