package com.SWE573.dutluk_backend.request;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
public class RecommendationRequest {

    private String userId; // must be changed to string

    private Set<String> excludedIds = new HashSet<>(); // equals to likedStories' id note: convert long to String

    private String vector_type; // either story or user
}
