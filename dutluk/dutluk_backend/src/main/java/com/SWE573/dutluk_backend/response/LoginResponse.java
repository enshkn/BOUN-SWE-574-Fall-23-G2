package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginResponse {
    private Long id;
    private String email;

    private String username;

    private String profilePhoto;

    private String biography;

    private String token;

    public LoginResponse(User user,String token) {
        this.id = user.getId();
        this.email = user.getEmail();
        this.username = user.getUsername();
        this.profilePhoto = user.getProfilePhoto();
        this.biography = user.getBiography();
        this.token = token;
    }
}
