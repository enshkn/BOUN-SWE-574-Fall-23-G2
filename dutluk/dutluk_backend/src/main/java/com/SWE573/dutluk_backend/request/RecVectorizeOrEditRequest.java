package com.SWE573.dutluk_backend.request;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Builder
@Data
public class RecVectorizeOrEditRequest { // vectorize && vectorize-edit

    private String type;

    private String ids;

    private List<String> tags;

    private String text;


}
