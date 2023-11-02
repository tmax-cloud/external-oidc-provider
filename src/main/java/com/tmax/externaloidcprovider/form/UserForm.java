package com.tmax.externaloidcprovider.form;

import lombok.Data;
import org.springframework.lang.Nullable;

@Data
public class UserForm {
    @Nullable
    private String id;
    @Nullable
    private String username;
    @Nullable
    private String email;
}
