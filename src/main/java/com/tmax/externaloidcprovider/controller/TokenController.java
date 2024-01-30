package com.tmax.externaloidcprovider.controller;

import com.google.gson.JsonObject;
import com.tmax.externaloidcprovider.constant.OidcPath;
import com.tmax.externaloidcprovider.form.TokenForm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(OidcPath.token)
public class TokenController {

    private static final Logger logger = LogManager.getLogger(TokenController.class);

    @PostMapping
    public TokenForm token(@RequestParam(required = false) String grant_type,
                           @RequestParam(required = false) String code,
                           @RequestParam(required = false) String redirect_uri,
                           @RequestParam(required = false) String client_id,
                           @RequestParam(required = false) String client_secret){

        logger.info("grant_type: " + grant_type);
        logger.info("code: " + code);
        logger.info("redirect_uri: " + redirect_uri);
        logger.info("client_id: " + client_id);
        logger.info("client_secret: " + client_secret);

        JsonObject accessToken = new JsonObject();
        accessToken.addProperty("user_id", code);

        TokenForm tokenForm = new TokenForm();
        tokenForm.setAccess_token(accessToken.toString()); //임시로 이메일 전달을 위해
        tokenForm.setToken_type("bearer");
        tokenForm.setExpires_in(99999999);
        tokenForm.setRefresh_token(accessToken.toString());
        tokenForm.setRefresh_expires_in(99999999);
        tokenForm.setScope("read write");
        tokenForm.setId_token(accessToken.toString());

        return tokenForm;
    }
}
