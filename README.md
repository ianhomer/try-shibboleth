# try-shibboleth

Try creating an SP using an shibboleth IDP

# TL;DR

    mvn install
    docker-compose up -d

Configure local environment to point to an IDP - see below for details.

Access

    http://localhost

# Test SP direct

    mvn spring-boot:run -pl sp

And access

    http://localhost:8080/

# Full rebuild

    mvn clean install && docker-compose up -d --build ;and docker-compose logs -f

Just apache

    docker-compose up -d --build apache ;and docker-compose logs -f apache

Just SP

    mvn install ;and  docker-compose up -d --build sp ;and docker-compose logs -f sp

# Local configuration

Copy samples from apache/config/shibboleth to apache/build/config/shibboleth and then copy in any of your required
certificates.

  export LOCAL_CONFIG_DIR=./build/config

# IDP Configurations

## SSOCircle

(not working for me yet :( )

Upload meta data from samples/ssocircle-metadata.xml to sso circle profile

```
export IDP_DOMAIN=idp.ssocircle.com
export IDP_HTTP_REDIRECT_PATH=/sso/SSORedirect/metaAlias/publicidp
```

## Okta

Create your app in Okta and then extract value, for example

```
export IDP_DOMAIN=purplepip.okta.com
export IDP_HTTP_REDIRECT_PATH=/app/purplepip_dojo_1/exk3ejh2xT5Tnn8Az356/sso/saml
```


# Troubleshooting

Shibboleth
* logs : /var/log/shibboleth
* config : /etc/shibboleth

View shibboleth metadata.xml

    docker exec -it dojo-apache cat /etc/shibboleth/metadata/idp.xml
    docker exec -it dojo-apache cat /etc/shibboleth/metadata/sp.xml

# Further Reading

https://wiki.shibboleth.net/confluence/display/SP3/Apache

