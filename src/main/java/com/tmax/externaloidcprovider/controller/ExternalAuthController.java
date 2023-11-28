package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.constant.OidcPath;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ExternalAuthController {

    private static final Logger logger = LogManager.getLogger(ExternalAuthController.class);

    @GetMapping(value = OidcPath.auth)
    public ModelAndView auth(@RequestParam(required = false) String state, @RequestParam(required = false) String redirect_uri) {

        logger.info("state: " + state);
        logger.info("redirect_uri: " + redirect_uri);

        ModelAndView mav = new ModelAndView();
        if(state != null) mav.addObject("state", state);
        if(redirect_uri != null) mav.addObject("redirect_uri", redirect_uri);
        mav.setViewName("login_exec");
        return mav;
    }
}
