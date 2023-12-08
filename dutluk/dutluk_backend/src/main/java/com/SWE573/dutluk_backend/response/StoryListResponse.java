package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.service.ImageService;
import com.SWE573.dutluk_backend.service.StoryService;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
public class StoryListResponse{
    private Long id;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
    private Date createdAt;

    private List<String> pictures;

    private String title;

    private List<String> labels;

    @JsonIncludeProperties(value = {"id" , "username","profilePhoto"})
    private User user;

    private Set<Long> likes;

    private Set<Long> savedBy;

    @JsonIncludeProperties({"locationName"})
    private List<Location> locations;


    private String startTimeStamp;


    private String endTimeStamp;

    private String season;

    private String decade;

    public StoryListResponse(Story story) {
        this.id = story.getId();
        this.createdAt = story.getCreatedAt();
        this.pictures = ImageService.extractImageLinks(story.getText());
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.likes = story.getLikes();
        this.savedBy = story.getSavedBy();
        this.locations = story.getLocations();
        this.startTimeStamp = StoryService.dateToStringBasedOnHourFlag(story.getStartTimeStamp(),story.getStartHourFlag());
        this.endTimeStamp = StoryService.dateToStringBasedOnHourFlag(story.getEndTimeStamp(),story.getEndHourFlag());
        this.season = story.getSeason();
        this.decade = story.getDecade();
    }
}
