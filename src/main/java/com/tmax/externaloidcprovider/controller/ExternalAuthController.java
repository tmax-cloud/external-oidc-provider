package com.tmax.externaloidcprovider.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ExternalAuthController {

    @GetMapping(value = "/externalauth")
    public ModelAndView auth(@RequestParam(required = false) String state, @RequestParam(required = false) String redirect_uri) {
        System.out.println("state = " + state + ", redirect_uri = " + redirect_uri);
        ModelAndView mav = new ModelAndView();
        if(state != null) mav.addObject("state", state);
        if(redirect_uri != null) mav.addObject("redirect_uri", redirect_uri);
        mav.setViewName("login_exec");
        return mav;
    }
}
