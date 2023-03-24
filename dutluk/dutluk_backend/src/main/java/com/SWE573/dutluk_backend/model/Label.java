package com.SWE573.dutluk_backend.model;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name="labels")
@Getter
@Setter
public class Label extends BaseEntity{

    @Column(name = "story_id")
    private Long storyId;
    @Column(name = "label_text")
    private String labelText;
}
