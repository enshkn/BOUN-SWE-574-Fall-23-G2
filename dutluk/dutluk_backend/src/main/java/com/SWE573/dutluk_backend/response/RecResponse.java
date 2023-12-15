package com.SWE573.dutluk_backend.response;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
public class RecResponse {
    List<Long> ids;
    List<Double> scores;
}
