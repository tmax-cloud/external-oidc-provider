package com.tmax.externaloidcprovider.form;

import lombok.Data;
import org.springframework.lang.Nullable;

@Data
public class TokenForm {
    @Nullable
    private String access_token;
    @Nullable
    private long expires_in;
    @Nullable
    private long refresh_expires_in;
    @Nullable
    private String refresh_token;
    @Nullable
    private String token_type;
    @Nullable
    private String id_token;
    @Nullable
    private String not_before_policy;
    @Nullable
    private String session_state;

    @Nullable
    private String scope;

    @Nullable
    private String error;

    @Nullable
    private String error_description;

    @Nullable
    private String error_uri;
}
