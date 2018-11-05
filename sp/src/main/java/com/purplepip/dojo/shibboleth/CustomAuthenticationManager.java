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

import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

/**
 * Custom authentication manager.
 */
@Component
@Slf4j
public class CustomAuthenticationManager implements AuthenticationManager {
  @Override
  public Authentication authenticate(Authentication authentication) throws AuthenticationException {
    if (authentication.getCredentials() instanceof RemoteUserLoginFilter.PreAuthenticated) {
      LOG.info("Trusted {} : {}", authentication.isAuthenticated(), authentication);
      return new CustomAuthentication(
          authentication.getPrincipal(), authentication.getCredentials());
    }
    return authentication;
  }

  public static class CustomAuthentication extends AbstractAuthenticationToken {
    private Object credentials;
    private Object principal;

    private CustomAuthentication(Object principal, Object credentials) {
      super(List.of(new SimpleGrantedAuthority("ROLE_USER")));
      this.credentials = credentials;
      this.principal = principal;
      this.setAuthenticated(true);
    }

    @Override
    public Object getCredentials() {
      return credentials;
    }

    @Override
    public Object getPrincipal() {
      return principal;
    }
  }
}
