package com.purplepip.dojo.shibboleth;

import java.time.LocalDate;
import java.util.Collections;
import java.util.function.Function;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
public class HomeController {
  @RequestMapping("/")
  public String index(HttpServletRequest request, Model model) {
    model.addAttribute(
        "headers",
        Collections.list(request.getHeaderNames())
            .stream()
            .collect(Collectors.toMap(Function.identity(), request::getHeader)));
    LOG.info("Remote User = {}", request.getRemoteUser());
    model.addAttribute("remoteUser", request.getRemoteUser());
    model.addAttribute("now", LocalDate.now());
    return "index";
  }
}
