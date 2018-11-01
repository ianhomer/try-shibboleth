package com.purplepip.dojo.shibboleth;

import lombok.extern.slf4j.Slf4j;
import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@Slf4j
public class Ajp {
  @Value("${tomcat.ajp.port:8009}")
  private int port;

  @Bean
  public WebServerFactoryCustomizer<TomcatServletWebServerFactory> servletContainer() {
    return server -> {
      if (server != null) {
        LOG.info("Configuring AJP connector");
        Connector connector = new Connector("AJP/1.3");
        connector.setScheme("http");
        connector.setPort(port);
        connector.setSecure(false);
        connector.setAllowTrace(false);

        server.addAdditionalTomcatConnectors(connector);
      }
    };
  }
}
