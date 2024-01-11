package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.constant.OidcPath;
import com.tmax.externaloidcprovider.form.UserForm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(OidcPath.user)
public class UserController {

    private static final Logger logger = LogManager.getLogger(UserController.class);

    @GetMapping
    public UserForm user(@RequestParam(required = false) String access_token){

        logger.info("access_token: " + access_token);

        UserForm userForm = new UserForm();
        userForm.setId(access_token);
        userForm.setUsername(access_token);
        userForm.setFirstName("tmax");
        userForm.setLastName("kim");


        /* Disable email information.
         to use this, should disable login with email and enable duplicate email
         in keycloak realm login setting.
         */

        logger.info("userId: " + userForm.getId());
        logger.info("username: " + userForm.getUsername());
        logger.info("email: " + userForm.getEmail());

        return userForm;
    }
}
