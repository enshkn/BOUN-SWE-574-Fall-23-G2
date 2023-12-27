package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.service.ImageService;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.OneToMany;
import lombok.Data;

import java.util.List;
import java.util.Set;

import static com.SWE573.dutluk_backend.service.DateService.dateToStringBasedOnFlags;
import static com.SWE573.dutluk_backend.service.DateService.timeAgo;
import static com.SWE573.dutluk_backend.service.StoryService.generateVerbalExpression;

@Data
public class MyStoryListResponse {

    private Long id;

    private String createdAt;

    private String picture;

    private String text;


    private String title;


    private List<String> labels;


    @JsonIncludeProperties(value = {"id", "username", "profilePhoto"})
    private User user;

    @OneToMany(mappedBy = "story")
    private List<Comment> comments;

    private Set<Long> likes;
    private Integer likeSize;
    private Set<Long> savedBy;

    private List<Location> locations;

    private String startTimeStamp;

    private String endTimeStamp;

    private String season;

    private String endSeason;

    private String decade;

    private String endDecade;

    private String verbalExpression;

    private Integer startHourFlag;// if 0, no hour, if 1, hour exists

    private Integer endHourFlag;// if 0, no hour, if 1, hour exists

    private Integer startDateFlag;// if 1 -> yyyy, if 2 -> MM/yyyy, if 3 dd/MM/yyyy

    private Integer endDateFlag;// if 1 -> yyyy, if 2 -> MM/yyyy, if 3 dd/MM/yyyy

    public MyStoryListResponse(Story story) {
        this.id = story.getId();
        this.createdAt = timeAgo(story.getCreatedAt());
        this.picture = ImageService
                .extractFirstImageLink(story.getText());
        this.text = story.getText();
        this.title = story.getTitle();
        this.labels = story.getLabels();
        this.user = story.getUser();
        this.comments = story.getComments();
        this.likes = story.getLikes();
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
        this.startHourFlag = story.getStartHourFlag();
        this.startDateFlag = story.getStartDateFlag();
        this.endHourFlag  = story.getEndHourFlag();
        this.endDateFlag = story.getEndDateFlag();
        this.season = story.getSeason();
        this.endSeason = story.getEndSeason();
        this.decade = story.getDecade();
        this.endDecade = story.getEndDecade();
        this.verbalExpression = generateVerbalExpression(story);

    }


}