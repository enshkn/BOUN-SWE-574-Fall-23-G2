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
public class StoryListResponse {
    private Long id;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm", timezone = "Europe/Istanbul")
    private Date createdAt;

    private String picture;

    private String title;

    private List<String> labels;

    @JsonIncludeProperties(value = {"id","username","profilePhoto"})
    private User user;

    private Integer likeSize;

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
        this.picture = ImageService
                .extractImageLinks(story.getText());
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.likeSize = story.getLikes().size();
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
        this.decade = StoryService.getDecadeString(story);
    }
}
