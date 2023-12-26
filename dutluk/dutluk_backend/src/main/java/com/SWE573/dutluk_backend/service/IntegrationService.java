package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.response.Response;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Collection;

@Service
public class IntegrationService {



    public static ResponseEntity<?> mobileCheck (HttpServletRequest request, Object entity, HttpStatus httpStatus){
        String userAgent = request.getHeader("User-Agent");
        Response successfulResponse = new SuccessfulResponse();
        if(userAgent.contains("Dart")){
            successfulResponse.setEntity("");
            successfulResponse.setStatus(httpStatus.value());
            successfulResponse.setMessage(entity.toString());
            successfulResponse.setSuccess(false);
            if(entity instanceof Collection<?>){
                successfulResponse.setCount(((Collection<?>) entity).size());
            }
            return new ResponseEntity<>(successfulResponse,HttpStatus.OK);
        }
        else{
            return new ResponseEntity<>(entity,httpStatus);
        }
    }
    public static ResponseEntity<?> mobileCheck (HttpServletRequest request, Object entity){
        String userAgent = request.getHeader("User-Agent");
        Response successfulResponse = new SuccessfulResponse();
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
