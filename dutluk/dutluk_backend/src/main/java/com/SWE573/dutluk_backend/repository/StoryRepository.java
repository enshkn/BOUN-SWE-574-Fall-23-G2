package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Story;
import org.springframework.data.repository.CrudRepository;

public interface StoryRepository extends CrudRepository<Story,Long> {
}
