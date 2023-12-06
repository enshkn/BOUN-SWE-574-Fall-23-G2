package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import org.junit.jupiter.api.Test;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;


class IntegrationServiceTest {

    @Test
    void testMobileCheckWithDartUserAgent() {

        String nonDartUserAgent = "Some Dart User Agent";
        Object entity = mock(Object.class);
        ResponseEntity<?> responseEntity = IntegrationService.mobileCheck(nonDartUserAgent, entity);
        assertEquals(200, responseEntity.getStatusCodeValue());
        assertEquals(SuccessfulResponse.class, responseEntity.getBody().getClass());
    }

    @Test
    void testMobileCheckWithNonDartUserAgent() {
        String nonDartUserAgent = "Some User Agent";
        Object entity = mock(Object.class);
        ResponseEntity<?> responseEntity = IntegrationService.mobileCheck(nonDartUserAgent, entity);
        assertEquals(200, responseEntity.getStatusCodeValue());
        assertEquals(entity, responseEntity.getBody());
    }
}
