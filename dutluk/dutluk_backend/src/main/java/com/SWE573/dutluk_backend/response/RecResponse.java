package com.SWE573.dutluk_backend.response;

import lombok.Data;

import java.util.List;
@Data
public class RecResponse {
    List<Long> ids;
    List<Double> scores;
}
