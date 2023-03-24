package com.SWE573.dutluk_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;

@Entity
@Table(name="users")
@Getter
@Setter
public class User extends BaseEntity{

    @NotBlank
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

}
