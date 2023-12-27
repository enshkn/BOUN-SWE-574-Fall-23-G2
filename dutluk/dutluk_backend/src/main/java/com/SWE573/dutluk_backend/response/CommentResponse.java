package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Data;

import java.util.Set;

import static com.SWE573.dutluk_backend.service.DateService.timeAgo;

@Data
public class CommentResponse {

    private String createdAt;
    private String text;

    @JsonIncludeProperties(value = {"id","username","profilePhoto"})
    private User user;

    @JsonIgnore
    private Story story;

    private Set<Long> likes;

    private Integer likeSize;

    public CommentResponse(Comment comment) {
        this.createdAt = timeAgo(comment.getCreatedAt());
        this.text = comment.getText();
        this.user = comment.getUser();
        this.story = comment.getStory();
        this.likes = comment.getLikes();
        this.likeSize = comment.getLikes().size();
    }
}