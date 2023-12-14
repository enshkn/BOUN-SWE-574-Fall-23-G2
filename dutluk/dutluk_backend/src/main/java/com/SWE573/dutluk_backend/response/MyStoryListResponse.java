package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.service.StoryService;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.CascadeType;
import jakarta.persistence.OneToMany;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

public class MyStoryListResponse {

    private Long id;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm", timezone = "Europe/Istanbul")
    private Date createdAt;

    private String text;


    private String title;


    private List<String> labels;


    @JsonIncludeProperties(value = {"id" , "username"})
    private User user;

    @OneToMany(mappedBy = "story")
    private List<Comment> comments;

    private Integer likeSize;
    private Set<Long> savedBy;

    @OneToMany(mappedBy = "story", cascade = CascadeType.ALL)
    private List<Location> locations = new ArrayList<>();

    private String startTimeStamp;

    private String endTimeStamp;

    private String season;

    private String decade;

    public MyStoryListResponse(Story story) {
        this.id = story.getId();
        this.createdAt = story.getCreatedAt();
        this.text = story.getText();
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.comments = story.getComments();
        this.likeSize = story.getLikes().size();
        this.savedBy = story.getSavedBy();
        this.locations = story.getLocations();
        this.startTimeStamp = StoryService.dateToStringBasedOnFlags(story.getStartTimeStamp(),story.getStartHourFlag(),story.getStartDateFlag());
        this.endTimeStamp = StoryService
                .dateToStringBasedOnFlags(
                        story.getEndTimeStamp(),
                        story.getEndHourFlag(),
                        story.getEndDateFlag());
        this.season = story.getSeason();
        this.decade = story.getDecade();
    }


}
