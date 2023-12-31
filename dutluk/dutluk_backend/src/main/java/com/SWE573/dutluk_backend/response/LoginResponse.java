package com.SWE573.dutluk_backend.response;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import lombok.Data;

import java.util.List;
import java.util.Map;
import java.util.Set;

@Data
public class LoginResponse {
    private Long id;
    private String email;

    private String username;

    private String profilePhoto;

    private String biography;


    @JsonIncludeProperties({"id","title"})
    private List<Story> stories;

    private Set<Long> likedStories;

    @JsonIgnore
    private Set<Long> savedStories;

    private Map<Long, Integer> recommendedStoriesMap;

    @JsonIncludeProperties({"id","username"})
    private Set<User> followers;


    @JsonIncludeProperties({"id","username"})
    private Set<User> following;

    private String token;

    public LoginResponse(User user,String token) {
        this.id = user.getId();
        this.email = user.getEmail();
        this.username = user.getUsername();
        this.profilePhoto = user.getProfilePhoto();
        this.biography = user.getBiography();
        this.stories = user.getStories();
        this.likedStories = user.getLikedStories();
        this.savedStories = user.getSavedStories();
        this.recommendedStoriesMap = user.getRecommendedStoriesMap();
        this.followers = user.getFollowers();
        this.following = user.getFollowing();
        this.token = token;
    }
}
