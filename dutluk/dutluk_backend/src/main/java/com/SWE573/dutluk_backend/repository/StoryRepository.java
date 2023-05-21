package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Story;
import org.springframework.data.repository.CrudRepository;

import java.time.LocalDate;
import java.util.List;


public interface StoryRepository extends CrudRepository<Story,Long> {
    List<Story> findAll();
    List<Story> findByUserId(Long userId);

    List<Story> findByTitleContainingIgnoreCase(String query);

    List<Story> findByLabelsContainingIgnoreCase(String query);

    List<Story> findByLocations_LatitudeBetweenAndLocations_LongitudeBetween(double minLatitude, double maxLatitude, double minLongitude, double maxLongitude);
    List<Story> findByTitleContainingIgnoreCaseAndLocations_LatitudeBetweenAndLocations_LongitudeBetween(String query, double minLatitude, double maxLatitude, double minLongitude, double maxLongitude);

    List<Story> findByDecadeContainingIgnoreCase(String query);

    List<Story> findBySeasonContainingIgnoreCase(String query);

    List<Story> findByStartTimeStampBetween(LocalDate startDate, LocalDate endDate);

    List<Story> findByStartTimeStamp(LocalDate startTimeStamp);
}
