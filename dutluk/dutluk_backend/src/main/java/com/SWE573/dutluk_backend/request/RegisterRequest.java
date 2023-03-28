package com.SWE573.dutluk_backend.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {

    private String email;
    private String username;

    private String password;
}
