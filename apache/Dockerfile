FROM httpd:2.4

ARG LOCAL_CONFIG_DIR

RUN apt-get update --fix-missing
RUN apt-get -y install libapache2-mod-shib2 procps
RUN cp /usr/lib/apache2/modules/mod_shib2.so /usr/local/apache2/modules

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /var/run/shibboleth
COPY ./shibboleth/ /etc/shibboleth/

RUN echo "Local configuration directory : ${LOCAL_CONFIG_DIR}"
RUN mkdir /config

COPY ./scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

COPY ./config/shibboleth/ /config/shibboleth/
ADD ${LOCAL_CONFIG_DIR}/shibboleth/ /config/shibboleth/

CMD docker-container-cmd.sh

