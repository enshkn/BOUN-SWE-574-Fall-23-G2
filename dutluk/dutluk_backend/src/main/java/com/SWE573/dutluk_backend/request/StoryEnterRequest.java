package com.SWE573.dutluk_backend.request;

import com.SWE573.dutluk_backend.model.Location;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class StoryEnterRequest {
    private String text;


    private String title;
    private List<String> labels;

    private List<Location> locations;



    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Europe/Istanbul")
    private Date startTimeStamp;


    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Europe/Istanbul")
    private Date endTimeStamp;

    private String season;

    private String endSeason;

    private String decade;

    private String endDecade;


    private Integer startHourFlag = -1;// if 0, no hour, if 1, hour exists

    private Integer endHourFlag = -1;// if 0, no hour, if 1, hour exists

    private Integer startDateFlag = -1;// if 1 -> yyyy, if 2 -> MM/yyyy, if 3 dd/MM/yyyy

    private Integer endDateFlag = -1;;// if 1 -> yyyy, if 2 -> MM/yyyy, if 3 dd/MM/yyyy

    private String timeType; //takes the value "time_point" or "time_interval";

    private String timeExpression;// takes the value "moment","day","month+season","year","decade" or "decade+season"
}
