package com.SWE573.dutluk_backend.request;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;

@Getter
@Setter
public class StoryCreateRequest {
    private String text;

    private String title;
    private ArrayList<String> labels = new ArrayList<>();

    private Double latitude;
    private Double longitude;
}
