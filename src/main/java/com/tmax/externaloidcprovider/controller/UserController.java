package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.form.UserForm;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/user")
public class UserController {

    @GetMapping
    public UserForm user(@RequestParam(required = false) String access_token){
        System.out.println("UserController.user");
        System.out.println("access_token = " + access_token);
        UserForm userForm = new UserForm();
        userForm.setId(String.valueOf(UUID.randomUUID()));
        userForm.setUsername("woo");
        userForm.setEmail(access_token); //임시로 email 전달을 위해
        return userForm;
    }
}
