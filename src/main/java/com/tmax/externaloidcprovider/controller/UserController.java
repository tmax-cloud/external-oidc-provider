package com.tmax.externaloidcprovider.controller;

import com.initech.eam.api.NXUserInfo;
import com.tmax.externaloidcprovider.constant.OidcPath;
import com.tmax.externaloidcprovider.form.UserForm;
import com.tmax.externaloidcprovider.global.NXUserRepository;
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

        logger.info("userId as access_token : " + access_token);

        UserForm userForm = new UserForm();
        userForm.setId(access_token);
        userForm.setUsername(access_token);

        try{
            NXUserInfo userInfo = NXUserRepository.getInstance().getUserInfo(access_token);
            userForm.setEmail(userInfo.getEmail());
            userForm.setFirstName(userInfo.getName());
            NXUserRepository.getInstance().removeUserInfo(access_token);
        }catch (NullPointerException e){
            logger.error(e.getMessage());
            logger.error("No userinfo in NXuserRepository. Skip getting detailed user info.");
        }
        logger.info("userId: " + userForm.getId());
        logger.info("username: " + userForm.getUsername());
        logger.info("email: " + userForm.getEmail());
        logger.info("firstName: " + userForm.getFirstName());

        return userForm;
    }
}
