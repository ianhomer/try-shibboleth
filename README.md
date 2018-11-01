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

    mvn clean install && docker-compose up -d --build && docker-compose logs -f

Just apache

    docker-compose up -d --build apache && docker-compose logs -f

Just SP

    docker-compose up -d --build sp && docker-compose logs -f sp
