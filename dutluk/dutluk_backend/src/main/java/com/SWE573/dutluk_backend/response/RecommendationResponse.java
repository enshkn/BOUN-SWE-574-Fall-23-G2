package com.SWE573.dutluk_backend.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
@Getter
@Setter
public class RecommendationResponse {
    private String ids;
    private String text;

    private List<String> tags = new ArrayList<>();

    private String type = "story";
}
