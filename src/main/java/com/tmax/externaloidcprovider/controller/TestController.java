package com.tmax.externaloidcprovider.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequestMapping("/test")
public class TestController {

    @Value("${spring.mvc.view.prefix}")
    String jspPath;

    @GetMapping(value = "/v1")
    public ModelAndView auth(@RequestParam(required = false) String key1, @RequestParam(required = false) String key2) {
        System.out.println("key1 = " + key1 + ", redirect_uri = " + key2);
        System.out.println("jsp file path : " + jspPath);
        ModelAndView mav = new ModelAndView();
        mav.addObject("key1",key1);
        mav.addObject("key2",key2);
        mav.setViewName("test");
        return mav;
    }
}
