package com.SWE573.dutluk_backend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.*;

@Entity
@Table(name="stories")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Story extends BaseEntity{


    @NotBlank
    @Lob
    private String text;

    @NotBlank
    private String title;

    @ElementCollection
    @Column
    private List<String> labels = new ArrayList<>();



    @JsonIncludeProperties(value = {"id" , "username"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @OneToMany(mappedBy = "story")
    private List<Comment> comments;

    @Column(name = "likes")
    private Set<Long> likes = new HashSet<>();


    private Set<Long> savedBy = new HashSet<>();

    public Set<Long> getSavedBy() {
        if(savedBy == null){
            savedBy = new HashSet<>();
        }
        return savedBy;
    }

    @OneToMany(mappedBy = "story", cascade = CascadeType.ALL)
    private List<Location> locations = new ArrayList<>();

    @Column(name = "start_time_stamp")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Europe/Istanbul")
    private Date startTimeStamp;

    @Column(name = "end_time_stamp")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Europe/Istanbul")
    private Date endTimeStamp;

    private String season;

    private String decade;

    private Integer startHourFlag;

    private Integer endHourFlag;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm", timezone = "Europe/Istanbul")
    public Date getStartTimeStamp() {
        if(startHourFlag != null && startHourFlag != 1){
            return getStartTimeStampWithoutTime();
        }
        return startTimeStamp;
    }
    @JsonFormat(pattern = "dd/MM/yyyy", timezone = "Europe/Istanbul")
    public Date getStartTimeStampWithoutTime() {
        return startTimeStamp;
    }

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm", timezone = "Europe/Istanbul")
    public Date getEndTimeStamp() {
        if(endHourFlag != null && endHourFlag == 1){
            return getEndTimeStampWithoutTime();
        }
        return startTimeStamp;
    }

    @JsonFormat(pattern = "dd/MM/yyyy", timezone = "Europe/Istanbul")
    public Date getEndTimeStampWithoutTime() {
        return endTimeStamp;
    }

}
