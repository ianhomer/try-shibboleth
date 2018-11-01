FROM httpd:2.4

RUN apt-get update --fix-missing
RUN apt-get -y install libapache2-mod-shib2 procps
RUN cp /usr/lib/apache2/modules/mod_shib2.so /usr/local/apache2/modules

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir -p /var/run/shibboleth

CMD /usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30 ; httpd-foreground

