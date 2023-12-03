package com.SWE573.dutluk_backend.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Getter
@Setter
public class RecStoryLikeOrDislikeRequest { // story-liked & story-disliked
    private String type;

    private String storyId;

    private String userId;

    private Integer userWeight;

}
