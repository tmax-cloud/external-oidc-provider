package com.tmax.externaloidcprovider.form;

import lombok.Data;
import org.springframework.lang.Nullable;

@Data
public class TokenForm {
    @Nullable
    private String access_token;
    @Nullable
    private String token_type;
    @Nullable
    private String refresh_token;
    @Nullable
    private long expires_in;
    @Nullable
    private String scope;

}
