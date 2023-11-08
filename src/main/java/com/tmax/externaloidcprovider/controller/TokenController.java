package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.form.TokenForm;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/token")
public class TokenController {

    @PostMapping
    public TokenForm token(@RequestParam(required = false) String grant_type,
                           @RequestParam(required = false) String code,
                           @RequestParam(required = false) String redirect_uri,
                           @RequestParam(required = false) String client_id,
                           @RequestParam(required = false) String client_secret){
        System.out.println("grant_type = " + grant_type + ", code = " + code + ", redirect_uri = " + redirect_uri + ", client_id = " + client_id + ", client_secret = " + client_secret);
        TokenForm tokenForm = new TokenForm();
        tokenForm.setAccess_token(code); //임시로 이메일 전달을 위해
        tokenForm.setToken_type("bearer");
        tokenForm.setExpires_in(43261566);
        tokenForm.setRefresh_token("refresh_token");
        return tokenForm;
    }
}
