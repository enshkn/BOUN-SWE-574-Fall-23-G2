package com.SWE573.dutluk_backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name="comments")
@Getter
@Setter
public class Comment extends BaseEntity{

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "comment_text")
    private String commentText;
}
