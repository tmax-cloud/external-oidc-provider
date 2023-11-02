package com.tmax.externaloidcprovider.form;

import lombok.Data;
import org.springframework.lang.Nullable;

@Data
public class LoginForm {
    @Nullable
    private String name;
    @Nullable
    private String password;
    @Nullable
    private String session_code;
    @Nullable
    private String tab_id;
    @Nullable
    private String client_id;
    @Nullable
    private String client_secret;
    @Nullable
    private String execution;
    @Nullable
    private String scope;
    @Nullable
    private String state;
    @Nullable
    private String response_type;
    @Nullable
    private String redirect_uri;
    @Nullable
    private String grant_type;
    @Nullable
    private String code;

}
