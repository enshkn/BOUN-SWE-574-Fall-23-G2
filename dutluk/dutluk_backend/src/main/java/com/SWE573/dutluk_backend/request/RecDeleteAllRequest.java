package com.SWE573.dutluk_backend.request;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecDeleteAllRequest {

    private String passWord;

    @Override
    public String toString() {
        return "RecDeleteAllRequest{" +
                "passWord='" + passWord + '\'' +
                '}';
    }
}
