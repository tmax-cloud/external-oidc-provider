package com.tmax.externaloidcprovider.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ExternalAuthController {
    @GetMapping(value = "/externalauth")
    public String auth(@RequestParam(required = false) String session_code,
                       @RequestParam(required = false) String tab_id,
                       @RequestParam(required = false) String client_id,
                       @RequestParam(required = false) String client_secret,
                       @RequestParam(required = false) String execution,
                       @RequestParam(required = false) String scope,
                       @RequestParam(required = false) String state,
                       @RequestParam(required = false) String response_type,
                       @RequestParam(required = false) String redirect_uri,
                       Model model){
        System.out.println("session_code = " + session_code + ", tab_id = " + tab_id + ", client_id = " + client_id + ", client_secret = " + client_secret + ", execution = " + execution + ", scope = " + scope + ", state = " + state + ", response_type = " + response_type + ", redirect_uri = " + redirect_uri + ", model = " + model);
        model.addAttribute("session_code",session_code);
        model.addAttribute("tab_id",tab_id);
        model.addAttribute("client_id",client_id);
        model.addAttribute("client_secret",client_secret);
        model.addAttribute("execution",execution);
        model.addAttribute("scope",scope);
        model.addAttribute("state",state);
        model.addAttribute("response_type",response_type);
        model.addAttribute("redirect_uri",redirect_uri);
        return "externalauth";
    }
}
