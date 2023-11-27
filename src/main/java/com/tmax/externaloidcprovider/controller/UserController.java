package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.form.UserForm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    private static final Logger logger = LogManager.getLogger(TokenController.class);

    @GetMapping
    public UserForm user(@RequestParam(required = false) String access_token){

        logger.info("access_token: " + access_token);

        UserForm userForm = new UserForm();
        userForm.setId(access_token);
        userForm.setUsername(access_token);
        return userForm;
    }
}
