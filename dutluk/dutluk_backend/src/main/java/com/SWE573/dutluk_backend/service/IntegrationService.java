package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.response.Response;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Collection;

@Service
public class IntegrationService {

    private static Response successfulResponse = new SuccessfulResponse();



    public static ResponseEntity<?> mobileCheck (String userAgent, Object entity, HttpStatus httpStatus){
        if(userAgent.contains("Dart")){
            successfulResponse.setEntity(entity);
            successfulResponse.setStatus(httpStatus.value());
            successfulResponse.setMessage("fail");
            successfulResponse.setSuccess(false);
            if(entity instanceof Collection<?>){
                successfulResponse.setCount(((Collection<?>) entity).size());
            }
            return new ResponseEntity<>(successfulResponse,httpStatus);
        }
        else{
            return new ResponseEntity<>(entity,httpStatus);
        }
    }
    public static ResponseEntity<?> mobileCheck (String userAgent, Object entity){
        if(userAgent.contains("Dart")){
            successfulResponse.setEntity(entity);
            if(entity instanceof Collection<?>){
                successfulResponse.setCount(((Collection<?>) entity).size());
            }
            return ResponseEntity.ok(successfulResponse);
        }
        else{
            return ResponseEntity.ok(entity);
        }
    }

}
