package com.SWE573.dutluk_backend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "locations")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Location extends BaseEntity{

    @Column(name="location_name")
    private String locationName;


    private Double latitude;

    private Double longitude;


    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "story_id", nullable = false)
    private Story story;

    private Integer isCircle;

    private Integer isPolyline;

    private Integer isPolygon;

    private Integer isPoint;

    private Integer circleRadius;

}
