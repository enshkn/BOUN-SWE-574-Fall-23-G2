package com.SWE573.dutluk_backend.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Builder
@Getter
@Setter
public class RecStoryOrUserRequest { // reccommend-story && recommend-user

    private String userId; // must be changed to string

    private Set<Long> excludedIds = new HashSet<>(); // equals to likedStories' id note: convert long to String

    private String vector_type; // either story or user
}
