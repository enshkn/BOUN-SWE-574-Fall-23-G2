package com.SWE573.dutluk_backend.request;

import lombok.Data;

@Data
public class LoginRequest {

    private String identifier;

    private String password;
}
