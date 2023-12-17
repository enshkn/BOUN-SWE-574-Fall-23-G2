package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.response.SuccessfulResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


class IntegrationServiceTest {

    @Test
    void testMobileCheckWithDartUserAgent() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getHeader("User-Agent")).thenReturn("Some Dart User Agent");
        Object entity = mock(Object.class);
        ResponseEntity<?> responseEntity = IntegrationService.mobileCheck(request, entity);
        assertEquals(200, responseEntity.getStatusCodeValue());
        assertEquals(SuccessfulResponse.class, responseEntity.getBody().getClass());
    }
    @Test
    void testMobileCheckWithHttpStatusWithDartUserAgent() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getHeader("User-Agent")).thenReturn("Some Dart User Agent");
        Object entity = mock(Object.class);
        ResponseEntity<?> responseEntity = IntegrationService.mobileCheck(request, entity, HttpStatus.NOT_FOUND);
        assertEquals(200, responseEntity.getStatusCodeValue());
        assertEquals(SuccessfulResponse.class, responseEntity.getBody().getClass());
    }

    @Test
    void testMobileCheckWithNonDartUserAgent() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getHeader("User-Agent")).thenReturn("Some User Agent");
        Object entity = mock(Object.class);
        ResponseEntity<?> responseEntity = IntegrationService.mobileCheck(request, entity);
        assertEquals(200, responseEntity.getStatusCodeValue());
        assertEquals(entity, responseEntity.getBody());
    }
}
