# Create keys and certificates

    export SECRET_DIR=$HOME/.config/secret
    export CERT_DIR=$HOME/.config/shibboleth
    mkdir -p $CERT_DIR
    openssl genrsa -out $SECRET_DIR/sp.pem 2048
    openssl req -new -x509 -key $SECRET_DIR/sp.pem -out $CERT_DIR/sp.cert