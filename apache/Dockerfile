FROM httpd:2.4

ARG LOCAL_CONFIG_DIR

#
# Install environment
#

RUN apt-get update --fix-missing
RUN apt-get -y install libapache2-mod-shib2 procps

#
# Copy Apache files into place
#
RUN cp /usr/lib/apache2/modules/mod_shib2.so /usr/local/apache2/modules
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf

#
# Copy configuration files into place
#
RUN mkdir -p /var/run/shibboleth
COPY ./shibboleth/ /etc/shibboleth/

RUN echo "Local configuration directory : ${LOCAL_CONFIG_DIR}"
RUN mkdir /config

COPY ./scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

COPY ./config/shibboleth/ /config/shibboleth/
ADD ${LOCAL_CONFIG_DIR}/shibboleth/ /config/shibboleth/
COPY ${LOCAL_CONFIG_DIR}/apache/certs/ /usr/local/apache2/conf/certs/
COPY ${LOCAL_CONFIG_DIR}/apache/keys/ /usr/local/apache2/conf/keys/

# Run the script to configure shibboleth and start apache
CMD docker-container-cmd.sh

