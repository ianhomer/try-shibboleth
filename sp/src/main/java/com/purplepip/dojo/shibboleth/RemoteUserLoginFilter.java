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

@Component
@Slf4j
public class RemoteUserLoginFilter extends AbstractPreAuthenticatedProcessingFilter {
  @Override
  protected Object getPreAuthenticatedPrincipal(HttpServletRequest httpServletRequest) {
    String subject = httpServletRequest.getHeader("REMOTE_USER");
    LOG.info("principal = {}", subject);
    if (subject != null) {
      return subject;
    }
    return null;
  }

  @Override
  protected Object getPreAuthenticatedCredentials(HttpServletRequest httpServletRequest) {
    return null;
  }

  @Override
  @Autowired
  public void setAuthenticationManager(AuthenticationManager authenticationManager) {
    super.setAuthenticationManager(authenticationManager);
  }
}
