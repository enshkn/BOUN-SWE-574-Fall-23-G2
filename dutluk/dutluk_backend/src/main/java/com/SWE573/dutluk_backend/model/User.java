package com.SWE573.dutluk_backend.model;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name="users")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class User extends BaseEntity{


    @Column(unique = true)
    @Email
    @NotBlank
    @NotNull
    private String email;

    @NotBlank
    @Column(unique = true)
    @NotNull
    private String username;

    @NotBlank
    @Column
    @JsonIgnore
    @NotNull
    private String password;

    @Lob
    private byte[] profilePhoto;

    @Column
    private String biography;



    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE, fetch = FetchType.LAZY)
    @JsonIncludeProperties({"story_id", "title"})
    private List<Story> stories;

    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.REMOVE, fetch = FetchType.LAZY)
    private List<Comment> comments;



    @JsonIgnoreProperties({"followers", "email" , "password" , "biography" , "stories","following"})
    @ManyToMany(fetch = FetchType.LAZY,cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinTable(
            name = "followers",
            joinColumns = @JoinColumn(name = "following_id"),
            inverseJoinColumns = @JoinColumn(name = "follower_id"))
    private Set<User> followers = new HashSet<>();

    @ManyToMany(mappedBy = "followers", fetch = FetchType.LAZY,cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JsonIgnoreProperties({"followers", "email" , "password" , "biography" , "stories","following"})
    private Set<User> following = new HashSet<>();

    @Transient
    private String token;
}
