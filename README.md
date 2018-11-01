# try-shibboleth

Try creating an SP using an shibboleth IDP

# TL;DR

    mvn install
    docker-compose up -d

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

    docker-compose up -d --build sp ;and docker-compose logs -f sp

# Troubleshooting

Shibboleth
* logs : /var/log/shibboleth
* config : /etc/shibboleth

View shibboleth metadata.xml

    docker exec -it dojo-apache cat /etc/shibboleth/metadata/sp.xml

# Further Reading

https://wiki.shibboleth.net/confluence/display/SP3/Apache

