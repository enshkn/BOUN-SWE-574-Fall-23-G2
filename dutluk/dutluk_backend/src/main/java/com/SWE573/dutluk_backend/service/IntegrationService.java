package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.response.Response;
import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.Set;

@Service
public class IntegrationService {

    private static Response successfulResponse = new SuccessfulResponse();



    public static ResponseEntity<?> mobileCheck (String userAgent,Object entity){
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
