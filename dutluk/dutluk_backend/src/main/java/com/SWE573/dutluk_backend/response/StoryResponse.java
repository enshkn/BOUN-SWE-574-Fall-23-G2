package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
public class StoryResponse extends Story{
    private Long id;

    private Date createdAt;

    private String title;

    private List<String> labels;

    @JsonIncludeProperties({"locationName"})
    private List<Location> locations;

    @JsonFormat(pattern="dd/MM/yyyy HH:mm",timezone = "Europe/Istanbul")
    private Date startTimeStamp;

    @JsonFormat(pattern="dd/MM/yyyy HH:mm",timezone = "Europe/Istanbul")
    private Date endTimeStamp;

    private String season;

    private String decade;

    private Set<Long> likes;

    private Set<Long> savedBy;

    public StoryResponse(Story story) {
        this.id = story.getId();
        this.createdAt = story.getCreatedAt();
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.locations = story.getLocations();
        this.startTimeStamp = story.getStartTimeStamp();
        this.endTimeStamp = story.getEndTimeStamp();
        this.season = story.getSeason();
        this.decade = story.getDecade();
        this.likes = story.getLikes();
        this.savedBy = story.getSavedBy();
    }
}
