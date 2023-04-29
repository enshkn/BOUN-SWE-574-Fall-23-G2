package com.SWE573.dutluk_backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name="times")
@Getter
@Setter
public class Time extends BaseEntity{
    @Column(name = "story_id")
    private Long storyId;
    @Column(name="time_type_flag")
    private int timeTypeFlag;// specific date = 0,start&end date=1,decade=2


}
