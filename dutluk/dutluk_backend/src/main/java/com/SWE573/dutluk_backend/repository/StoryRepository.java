package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Story;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface StoryRepository extends CrudRepository<Story,Long> {
    List<Story> findAll();
    List<Story> findByUserId(Long userId);
}
