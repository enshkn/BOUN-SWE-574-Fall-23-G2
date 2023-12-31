package com.SWE573.dutluk_backend.request;

import lombok.Data;

@Data
public class CommentRequest {

    private String commentText;
    private Long storyId;
}
