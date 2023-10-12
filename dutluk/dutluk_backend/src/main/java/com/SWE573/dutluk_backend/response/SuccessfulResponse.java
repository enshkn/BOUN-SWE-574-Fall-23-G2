package com.SWE573.dutluk_backend.response;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class SuccessfulResponse<T> extends Response{

    public SuccessfulResponse() {
        this.status = 200;
        this.success = true;
        this.message = "success";
    }
}
