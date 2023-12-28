package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {
    void deleteByStoryId(Long storyId);
}
