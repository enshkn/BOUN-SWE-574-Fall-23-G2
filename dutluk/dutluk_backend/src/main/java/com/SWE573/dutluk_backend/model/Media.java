package com.SWE573.dutluk_backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import javax.print.DocFlavor;

@Entity
@Table(name="medias")
@Getter
@Setter
public class Media extends BaseEntity{
    @Column(name = "story_id")
    private Long storyId;

    @Column(name = "media_file")
    private Byte[] mediaFile;

    @Column(name = "media_type")
    private Integer mediaType;
}
