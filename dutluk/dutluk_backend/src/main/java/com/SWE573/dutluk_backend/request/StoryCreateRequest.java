package com.SWE573.dutluk_backend.request;

import com.SWE573.dutluk_backend.model.Location;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;

@Getter
@Setter
public class StoryCreateRequest {
    private String text;


    private String title;
    private ArrayList<String> labels = new ArrayList<>();

    private ArrayList<Location> locations = new ArrayList<>();



    @JsonFormat(pattern="dd/MM/yyyy")
    private LocalDate startTimeStamp;


    @JsonFormat(pattern="dd/MM/yyyy")
    private LocalDate endTimeStamp;

    private String season;

    private String decade;
}
