package com.SWE573.dutluk_backend.request;

import com.SWE573.dutluk_backend.model.Location;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;

@Getter
@Setter
public class StoryEditRequest {
    private String text;

    private String title;

    private ArrayList<String> labels = new ArrayList<>();

    private ArrayList<Location> locations = new ArrayList<>();

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "UTC+3")
    private Date startTimeStamp;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "UTC+3")
    private Date endTimeStamp;

    private String season;

    private String decade;
}