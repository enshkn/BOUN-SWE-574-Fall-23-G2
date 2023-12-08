package com.SWE573.dutluk_backend.request;

import com.SWE573.dutluk_backend.model.Location;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;

@Getter
@Setter
public class StoryCreateRequest {
    private String text;


    private String title;
    private ArrayList<String> labels = new ArrayList<>();

    private ArrayList<Location> locations = new ArrayList<>();



    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Europe/Istanbul")
    private Date startTimeStamp;


    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Europe/Istanbul")
    private Date endTimeStamp;

    private String season;

    private String decade;

    private Integer startHourFlag = -1;// if 0, no hour, if 1, hour exists

    private Integer endHourFlag = -1;// if 0, no hour, if 1, hour exists

    private Integer startDateFlag = -1;// if 1 -> yyyy, if 2 -> MM/yyyy, if 3 dd/MM/yyyy

    private Integer endDateFlag = -1;;// if 1 -> yyyy, if 2 -> MM/yyyy, if 3 dd/MM/yyyy
}
