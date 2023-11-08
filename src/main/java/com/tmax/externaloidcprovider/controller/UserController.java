package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.db.User;
import com.tmax.externaloidcprovider.db.UserRepository;
import com.tmax.externaloidcprovider.form.UserForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserRepository userRepository;

    @GetMapping
    public UserForm user(@RequestParam(required = false) String access_token){
        System.out.println("access_token = " + access_token);
        UserForm userForm = new UserForm();
        User user = userRepository.findUserByEmail(access_token);
        userForm.setId(user.getId());
        userForm.setUsername(user.getUsername());
        userForm.setEmail(user.getEmail()); //임시로 email 전달을 위해
        return userForm;
    }
}
