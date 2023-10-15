package com.SWE573.dutluk_backend.configuration;

import com.SWE573.dutluk_backend.model.User;
import io.jsonwebtoken.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;

import static java.lang.Long.parseLong;

@Component
public class JwtUtil {

    @Value("${JWT_SECRET_KEY}")
    private String JWT_SECRET_KEY;
    @Value("${TOKEN_EXPIRATION_HOUR}")
    private long TOKEN_EXPIRATION_HOUR;

    public String generateToken(Long userId) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, userId);
    }

    private String createToken(Map<String, Object> claims, Long subject) {
        return Jwts.builder().setClaims(claims).setSubject(subject.toString())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * TOKEN_EXPIRATION_HOUR))// 10 hours
                .signWith(SignatureAlgorithm.HS256, JWT_SECRET_KEY).compact();

    }

    public Boolean validateToken(String token, User user) {
        try {
            final Long extractedUserId = extractId(token);
            return ((Objects.equals(extractedUserId, user.getId())) && !isTokenExpired(token));
        } catch (ExpiredJwtException | UnsupportedJwtException | MalformedJwtException | SignatureException | IllegalArgumentException ex) {
            return false;
        }
    }

    public Long extractId(String token) {
        return parseLong(extractClaim(token, Claims::getSubject));
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) throws ExpiredJwtException, UnsupportedJwtException, MalformedJwtException, SignatureException, IllegalArgumentException {
        return Jwts.parser().setSigningKey(JWT_SECRET_KEY).parseClaimsJws(token).getBody();
    }

    private Boolean isTokenExpired(String token) throws ExpiredJwtException, UnsupportedJwtException, MalformedJwtException, SignatureException, IllegalArgumentException {
        return extractExpiration(token).before(new Date());
    }
}



