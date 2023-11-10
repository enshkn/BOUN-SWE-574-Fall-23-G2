package com.SWE573.dutluk_backend.configuration;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Value("${FRONTEND_URL}")
    String FRONTEND_URL;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOriginPatterns("*")
                .allowedOrigins(FRONTEND_URL,"http://localhost:3000")
                .allowedMethods("*")
                .allowCredentials(true)
                .exposedHeaders("Set-Cookie")
                .allowedHeaders("*");
    }
}



