package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.service.StoryService;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
public class StoryResponse{
    private Long id;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm", timezone = "Europe/Istanbul")
    private Date createdAt;

    private String text;

    private String title;

    private List<String> labels;

    @JsonIncludeProperties(value = {"id" , "username","profilePhoto"})
    private User user;

    private List<Comment> comments;

    private Set<Long> likes;

    private Set<Long> savedBy;

    @JsonIgnoreProperties({"createdAt"})
    private List<Location> locations;

    private String startTimeStamp;

    private String endTimeStamp;

    private String season;

    private String decade;

    private String endDecade;

    private Integer percentage;

    private String verbalExpression;

    public StoryResponse(Story story) {
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
        this.startTimeStamp = StoryService
                .dateToStringBasedOnFlags(
                        story.getStartTimeStamp(),
                        story.getStartHourFlag(),
                        story.getStartDateFlag());
        this.endTimeStamp = StoryService
                .dateToStringBasedOnFlags(
                        story.getEndTimeStamp(),
                        story.getEndHourFlag(),
                        story.getEndDateFlag());
        this.season = story.getSeason();
        this.decade = story.getDecade();
        this.endDecade = StoryService
                .getEndDecadeString(story);
        this.percentage = story.getPercentage();
        this.verbalExpression = StoryService.generateVerbalExpression(story);
    }
}

