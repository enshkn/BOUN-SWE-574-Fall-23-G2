package com.SWE573.dutluk_backend.model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;

@Entity
@Table(name="users")
@Getter
@Setter
@RequiredArgsConstructor
public class User extends BaseEntity{


    @Column(unique = true)
    @Email
    private String email;

    @NotBlank
    @Column(unique = true)
    private String username;

    @NotBlank
    @Column
    @JsonIgnore
    private String password;

    @Column
    private String biography;

    @Column
    private ArrayList<Long> followers = new ArrayList<Long>();

    @Column
    private byte[] photo;


    @Column(unique = true)
    private String token;

    public User(String email, String username, String password) {
        this.email = email;
        this.username = username;
        this.password = password;
    }
}
