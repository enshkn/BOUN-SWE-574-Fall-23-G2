package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
public class StoryListResponse extends Story{
    private Long id;

    private Date createdAt;

    private String text;

    private String title;

    private List<String> labels;

    @JsonIncludeProperties(value = {"id" , "username","profilePhoto"})
    private User user;

    private List<Comment> comments;

    private Set<Long> likes;

    private Set<Long> savedBy;

    @JsonIncludeProperties({"locationName"})
    private List<Location> locations;

    @JsonFormat(pattern="dd/MM/yyyy HH:mm",timezone = "Europe/Istanbul")
    private Date startTimeStamp;

    @JsonFormat(pattern="dd/MM/yyyy HH:mm",timezone = "Europe/Istanbul")
    private Date endTimeStamp;

    private String season;

    private String decade;

    private Integer startHourFlag;

    private Integer endHourFlag;

    public StoryListResponse(Story story) {
        this.id = story.getId();
        this.createdAt = story.getCreatedAt();
        this.text = story.getText();
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.comments = story.getComments();
        this.likes = story.getLikes();
        this.savedBy = story.getSavedBy();
        this.locations = story.getLocations();
        this.startTimeStamp = story.getStartTimeStamp();
        this.endTimeStamp = story.getEndTimeStamp();
        this.season = story.getSeason();
        this.decade = story.getDecade();
        this.startHourFlag = story.getStartHourFlag();
        this.endHourFlag = story.getEndHourFlag();
    }
}
