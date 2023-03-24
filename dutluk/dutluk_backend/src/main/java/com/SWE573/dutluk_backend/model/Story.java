package com.SWE573.dutluk_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name="stories")
@Getter
@Setter
public class Story extends BaseEntity{

    @Column(name = "user_id")
    private Long userId;

    private String username;

    private String title;
    @Column(name = "story_text")
    private String storyText;

    @Column(name = "location_id")
    private Long locationId;
}
