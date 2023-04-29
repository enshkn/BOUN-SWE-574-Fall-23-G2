package com.SWE573.dutluk_backend.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateRequest {

    private byte[] photo;

    private String biography;
}
