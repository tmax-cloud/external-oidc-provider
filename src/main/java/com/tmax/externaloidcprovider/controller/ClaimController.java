package com.tmax.externaloidcprovider.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/claim")
public class ClaimController {
    @GetMapping
    public String auth(){
        return "claimFromSpring";
    }
}
