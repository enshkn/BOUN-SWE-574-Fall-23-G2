package com.SWE573.dutluk_backend.request;

import lombok.Builder;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

@Builder
@Data
public class RecStoryOrUserRequest { // recommend-story && recommend-user

    private String userId; // must be changed to string

    private Set<Long> excludedIds = new HashSet<>(); // equals to likedStories' id note: convert long to String

    private String vector_type; // either story or user
}
