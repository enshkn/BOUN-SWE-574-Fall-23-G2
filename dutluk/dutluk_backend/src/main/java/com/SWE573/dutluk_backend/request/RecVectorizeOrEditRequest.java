package com.SWE573.dutluk_backend.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Getter
@Setter
public class RecVectorizeOrEditRequest {

    private String text;

    private String ids;

    private String tags;

    private String type;
}
