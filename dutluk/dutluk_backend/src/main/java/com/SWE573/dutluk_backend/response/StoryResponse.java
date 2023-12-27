package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.service.DateService;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Data;

import java.util.List;
import java.util.Set;

import static com.SWE573.dutluk_backend.service.DateService.dateToStringBasedOnFlags;
import static com.SWE573.dutluk_backend.service.DateService.getEndDecadeStringByEndTimeStamp;
import static com.SWE573.dutluk_backend.service.StoryService.generateVerbalExpression;

@Data
public class StoryResponse{
    private Long id;


    private String createdAt;

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
        this.createdAt = DateService.timeAgo(story.getCreatedAt());
        this.text = story.getText();
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.comments = story.getComments();
        this.likes = story.getLikes();
        this.savedBy = story.getSavedBy();
        this.locations = story.getLocations();
        this.startTimeStamp = dateToStringBasedOnFlags(
                story.getStartTimeStamp(),
                story.getStartHourFlag(),
                story.getStartDateFlag());
        this.endTimeStamp = dateToStringBasedOnFlags(
                story.getEndTimeStamp(),
                story.getEndHourFlag(),
                story.getEndDateFlag());
        this.season = story.getSeason();
        this.decade = story.getDecade();
        this.endDecade = getEndDecadeStringByEndTimeStamp(story);
        this.percentage = story.getPercentage();
        this.verbalExpression = generateVerbalExpression(story);
    }
}