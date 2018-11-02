/*
 * Copyright (c) 2017 the original author or authors. All Rights Reserved
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.purplepip.dojo.shibboleth;

import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;
import org.springframework.stereotype.Component;

/**
 * Login filter that trust the REMOTE_USER header from upstream. This allows an upstream web server,
 * e.g. apache with shibboleth, to take control of pre-authorisation.
 */
@Component
@Slf4j
public class RemoteUserLoginFilter extends AbstractPreAuthenticatedProcessingFilter {
  private static final String SUBJECT_HEADER_NAME = "REMOTE_USER";

  @Override
  protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
    String subject = getSubject(request);
    LOG.info("subject = {}", subject);
    return subject;
  }

  @Override
  protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
    return getSubject(request) == null ? null : new PreAuthenticated();
  }

  private String getSubject(HttpServletRequest request) {
    String subject = request.getHeader(SUBJECT_HEADER_NAME);
    if (subject != null) {
      subject = subject.trim();
      if (subject.length() > 0) {
        return subject;
      }
    }
    return null;
  }

  @Override
  @Autowired
  public void setAuthenticationManager(AuthenticationManager authenticationManager) {
    super.setAuthenticationManager(authenticationManager);
  }

  public static class PreAuthenticated {}
}
