FROM httpd:2.4

RUN apt-get update --fix-missing                                                && \
    apt-get -y install libapache2-mod-shib2                                     && \
    cp /usr/lib/apache2/modules/mod_shib2.so /usr/local/apache2/modules

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf