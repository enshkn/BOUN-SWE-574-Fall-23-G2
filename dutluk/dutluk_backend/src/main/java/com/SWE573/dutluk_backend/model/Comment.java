package com.SWE573.dutluk_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name="comments")
@Getter
@Setter
public class Comment extends BaseEntity{

    @NotBlank
    @Column(columnDefinition = "TEXT")
    private String text;

    @JsonIgnoreProperties(value = {"followers", "email", "password", "biography", "stories", "following"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "story_id", nullable = false)
    private Story story;



    @Column
    private Set<Long> likes = new HashSet<>();

}
