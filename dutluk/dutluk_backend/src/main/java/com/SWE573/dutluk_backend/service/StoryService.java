package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class StoryService {

    @Autowired
    StoryRepository storyRepository;
    @Autowired
    private UserService userService;
    public List<Story> findAll(){
        return storyRepository.findAll();
    }

    public Story createStory(User foundUser, StoryCreateRequest storyCreateRequest){
        Story createdStory = Story.builder()
                .title(storyCreateRequest.getTitle())
                .labels(storyCreateRequest.getLabels())
                .text(storyCreateRequest.getText())
                .user(foundUser)
                .createdAt(new Date())
                .build();
        Location location = Location.builder()
                .latitude(storyCreateRequest.getLatitude())
                .longitude(storyCreateRequest.getLongitude())
                .story(createdStory)
                .build();
        List<Location> savedLocations = new ArrayList<>();
        savedLocations.add(location);
        createdStory.setLocations(savedLocations);
        return storyRepository.save(createdStory);
    }

    public List<Story> findAllStoriesByUserId(Long userId){
        return storyRepository.findByUserId(userId);
    }

    public Story getStoryByStoryId(Long id) {
        Optional<Story> optionalStory = storyRepository.findById(id);
        if (optionalStory.isEmpty()) {
            throw new NoSuchElementException("Story with id '" + id + "' not found");
        }
        return optionalStory.get();
    }
}
