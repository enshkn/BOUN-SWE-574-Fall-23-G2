package com.SWE573.dutluk_backend.response;

import lombok.Getter;
import lombok.Setter;

import java.util.Set;
@Getter
@Setter
public class RecResponse {
    Set<Long> ids;
    Set<Double> scores;
}
