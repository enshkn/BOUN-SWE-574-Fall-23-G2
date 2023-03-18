package com.SWE573.dutluk_backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name="users")
public class User extends BaseEntity{

    @NotBlank
    @Column
    @Email
    private String email;
}
