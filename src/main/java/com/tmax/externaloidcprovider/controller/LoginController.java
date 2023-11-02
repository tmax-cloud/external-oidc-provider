package com.tmax.externaloidcprovider.controller;

import com.tmax.externaloidcprovider.form.LoginForm;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.thymeleaf.util.StringUtils;

@Controller
public class LoginController {

    @PostMapping(value = "/login")
    public String login(LoginForm loginForm){
        System.out.println("/login called!!!!!" );
        System.out.println("loginForm = " + loginForm);
        String session_code = loginForm.getSession_code();
        String tab_id = loginForm.getTab_id();
        String client_id = loginForm.getClient_id();
        String execution = loginForm.getExecution();
        String state = loginForm.getState();
        String realm = "tmax";
        String code = loginForm.getName();

        if(StringUtils.isEmpty(state)){
            System.out.println("2차 인증 로그인");
            return "redirect:http://localhost:8080/auth/realms/"+realm+"/login-actions/authenticate?" +
                    "session_code="+session_code+"" +
                    "&tab_id="+tab_id+
                    "&client_id="+client_id+
                    "&execution="+execution;
        }else{
            System.out.println("소셜 로그인");
            return "redirect:http://localhost:8080/auth/realms/"+realm+"/broker/initech/endpoint?" +
                "&state="+state+
                "&code="+code;
        }
    }
}
