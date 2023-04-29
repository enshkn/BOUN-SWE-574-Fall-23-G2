package com.SWE573.dutluk_backend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.time.LocalDate;
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


    @Column
    private ArrayList<String> labels = new ArrayList<>();



    @JsonIncludeProperties(value = {"id" , "name"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @OneToMany(mappedBy = "story")
    private List<Comment> comments;

    private Set<Long> likes = new HashSet<>();

    @OneToMany(mappedBy = "story", cascade = CascadeType.ALL)
    private List<Location> locations = new ArrayList<>();

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @JsonFormat(pattern = "dd/MM/yyyy")
    @Column(name="start_time_stamp")
    private LocalDate startTimeStamp;

    @JsonFormat(pattern = "dd/MM/yyyy")
    @Column(name="end_time_stamp")
    private LocalDate endTimeStamp;

}
