package com.SWE573.dutluk_backend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name="times")
@Getter
@Setter
public class Time extends BaseEntity{
    @Column(name = "story_id")
    private Long storyId;
    @Column(name="time_type")
    private int timeType;


    private Long createdTimeStamp = System.currentTimeMillis();

    @JsonFormat(pattern = "dd/MM/yyyy")
    @Column(name="start_time_stamp")
    private LocalDate startTimeStamp;

    @JsonFormat(pattern = "dd/MM/yyyy")
    @Column(name="end_time_stamp")
    private LocalDate endTimeStamp;


}
