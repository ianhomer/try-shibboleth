# Create keys and certificates

    export SECRET_DIR=$HOME/.config/secret
    mkdir -p $SECRET_DIR
    export CERT_DIR=$HOME/.config/shibboleth
    mkdir -p $CERT_DIR

    openssl genrsa -out $SECRET_DIR/sp.key 2048
    openssl req -new -x509 -key $SECRET_DIR/sp.key -out $CERT_DIR/sp.crt

    openssl genrsa -out $SECRET_DIR/idp-signing.key 2048
    openssl req -new -x509 -key $SECRET_DIR/idp-signing.key -out $CERT_DIR/idp-signing.crt

    openssl genrsa -out $SECRET_DIR/idp-encryption.key 2048
    openssl req -new -x509 -key $SECRET_DIR/idp-encryption.key -out $CERT_DIR/idp-encryption.crt