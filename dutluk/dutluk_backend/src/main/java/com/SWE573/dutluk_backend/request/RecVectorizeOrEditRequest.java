package com.SWE573.dutluk_backend.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Builder
@Getter
@Setter
public class RecVectorizeOrEditRequest { // vectorize && vectorize-edit

    private String type;

    private Long ids;

    private List<String> tags;

    private String text;


}
