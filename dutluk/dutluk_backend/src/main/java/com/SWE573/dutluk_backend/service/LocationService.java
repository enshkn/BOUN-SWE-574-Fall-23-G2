package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.repository.LocationRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LocationService {

    @Autowired
    LocationRepository locationRepository;


    @Transactional
    public void deleteAllLocationsByStoryId(Long storyId) {
        locationRepository.deleteByStoryId(storyId);
    }
}
