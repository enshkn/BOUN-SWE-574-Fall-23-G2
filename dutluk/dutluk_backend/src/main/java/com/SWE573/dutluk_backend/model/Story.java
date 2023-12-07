package com.SWE573.dutluk_backend.model;

import com.SWE573.dutluk_backend.configuration.CustomDateDeserializer;
import com.SWE573.dutluk_backend.configuration.CustomDateSerializer;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
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
    @JsonSerialize(using = CustomDateSerializer.class)
    @JsonDeserialize(using = CustomDateDeserializer.class)
    private Date startTimeStamp;

    @Column(name = "end_time_stamp")
    @JsonSerialize(using = CustomDateSerializer.class)
    @JsonDeserialize(using = CustomDateDeserializer.class)
    private Date endTimeStamp;

    private String season;

    private String decade;

    private Integer startHourFlag;

    private Integer endHourFlag;

}
