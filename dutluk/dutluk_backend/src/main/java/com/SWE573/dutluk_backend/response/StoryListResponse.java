package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Data;

import java.util.List;
import java.util.Set;

import static com.SWE573.dutluk_backend.service.DateService.*;
import static com.SWE573.dutluk_backend.service.ImageService.extractFirstImageLink;
import static com.SWE573.dutluk_backend.service.StoryService.generateVerbalExpression;
import static com.SWE573.dutluk_backend.service.StoryService.getSubstring;

@Data
public class StoryListResponse {
    private Long id;

    private String createdAt;

    private String picture;

    private String text;

    private String title;

    private List<String> labels;

    @JsonIncludeProperties(value = {"id","username","profilePhoto"})
    private User user;

    private Integer commentSize;

    private Integer likeSize;

    private Set<Long> savedBy;

    @JsonIncludeProperties({"locationName"})
    private List<Location> locations;

    private String startTimeStamp;

    private String endTimeStamp;

    private String season;

    private String endSeason;

    private String decade;

    private String endDecade;

    private Integer percentage;

    private String verbalExpression;

    public StoryListResponse(Story story) {
        this.id = story.getId();
        this.createdAt = timeAgo(story.getCreatedAt());
        this.picture = extractFirstImageLink(story.getText());
        this.text = getSubstring(story.getText());
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.commentSize = story.getComments().size();
        this.likeSize = story.getLikes().size();
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
        this.endSeason = story.getEndSeason();
        this.decade = getDecadeStringByStartTimeStamp(story);
        this.endDecade = getEndDecadeStringByEndTimeStamp(story);
        this.percentage = story.getPercentage();
        this.verbalExpression = generateVerbalExpression(story);
    }
}