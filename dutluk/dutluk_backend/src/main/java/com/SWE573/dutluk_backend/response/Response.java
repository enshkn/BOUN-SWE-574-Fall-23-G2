package com.SWE573.dutluk_backend.response;


import lombok.Getter;

import lombok.Setter;

@Getter
@Setter
public class Response<T> {
    public int status = 200;

    public boolean success = true;

    public String message = "success";

    public int count = 0;

    public T entity = null;
}
