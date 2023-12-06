package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Story;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;


public interface StoryRepository extends JpaRepository<Story,Long> {
    List<Story> findAll();
    List<Story> findAllByOrderByIdDesc();
    List<Story> findByUserId(Long userId);

    List<Story> findByUserIdOrderByIdDesc(Long userId);

    List<Story> findByTitleContainingIgnoreCase(String query);

    List<Story> findByLabelsContainingIgnoreCase(String query);

    List<Story> findByLocations_LatitudeBetweenAndLocations_LongitudeBetween(double minLatitude, double maxLatitude, double minLongitude, double maxLongitude);
    List<Story> findByTitleContainingIgnoreCaseAndLocations_LatitudeBetweenAndLocations_LongitudeBetween(String query, double minLatitude, double maxLatitude, double minLongitude, double maxLongitude);

    List<Story> findByDecadeContainingIgnoreCase(String query);

    List<Story> findBySeasonContainingIgnoreCase(String query);

    List<Story> findByStartTimeStampBetween(Date startDate, Date endDate);

    List<Story> findByStartTimeStamp(Date startTimeStamp);

    List<Story> findByEndTimeStampBetween(Date startDecadeDate, Date endDecadeDate);

    List<Story> findByCreatedAtAfterOrderByIdDesc(Date date);
}
