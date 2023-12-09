package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.request.RecStoryLikeOrDislikeRequest;
import com.SWE573.dutluk_backend.request.RecVectorizeOrEditRequest;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.aspectj.lang.annotation.Before;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
@ExtendWith(MockitoExtension.class)
class RecommendationServiceTest {

    @Mock
    private RestTemplate restTemplate = new RestTemplate();

    @InjectMocks
    private RecommendationService recommendationService;

    @Mock
    private UserService userService;

    @Mock
    private StoryService storyService;

    private URI recUrl;

    @BeforeEach
    void setUp() {
        recommendationService.setRecUrl(URI.create("http://example.com"));
        recommendationService.setRecEngineStatus(true);
    }



    @Test
    public void testEndpoint_WhenKaradutIsOnline() {
        recommendationService.recEngineStatus = true;
        URI recUrl = recommendationService.getRecUrl();
        when(restTemplate.getForEntity(eq(recUrl+"/test"), eq(String.class)))
                .thenReturn(new ResponseEntity<>("Test Response", HttpStatus.OK));

        String result = recommendationService.testEndpoint();

        assertEquals("Test Response", result);
    }

    @Test
    void testEndpoint_WhenKaradutIsOffline() {
        // Given
        recommendationService.setRecEngineStatus(false);

        // When
        String result = recommendationService.testEndpoint();

        // Then
        assertEquals("Karadut implementation is offline", result);
    }
    @Test
    void vectorizeRequest_Successful() {
        User foundUser = User.builder()
                .username("testUser")
                .build();
        Story savedStory = Story.builder()
                .title("title")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .user(foundUser)
                .build();
        savedStory.setId(1L);

        // When
        String result = recommendationService.vectorizeRequest(savedStory);
        // Then
        assertEquals("Data sent to karadut", result);
    }

    @Test
    void vectorizeEditRequest_Successful() {
        User foundUser = User.builder()
                .username("testUser")
                .build();
        Story savedStory = Story.builder()
                .title("title")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .user(foundUser)
                .build();
        savedStory.setId(1L);

        String result = recommendationService.vectorizeRequest(savedStory);

        assertEquals("Data sent to karadut", result);
    }

    @Test
    void likedStory_Successful() throws JsonProcessingException {

        User foundUser = User.builder()
                .username("testUser")
                .build();
        Story savedStory = Story.builder()
                .title("title")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .user(foundUser)
                .build();
        foundUser.setId(1L);
        savedStory.setId(1L);
        Integer likedStorySize = 5;

        // When
        String result = recommendationService.likedStory(savedStory, foundUser, likedStorySize);

        // Then
        assertEquals("Recommendation complete", result);
    }

    @Test
    void dislikedStory_Successful() throws JsonProcessingException {

        User foundUser = User.builder()
                .username("testUser")
                .build();
        Story savedStory = Story.builder()
                .title("title")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .user(foundUser)
                .build();
        foundUser.setId(1L);
        savedStory.setId(1L);
        Integer likedStorySize = 5;

        // When
        String result = recommendationService.likedStory(savedStory, foundUser, likedStorySize);

        // Then
        assertEquals("Recommendation complete", result);
    }


    @Test
    void removeHtmlFormatting() {
        String input = "<p>Hello <b>World</b></p>";
        String expected = "Hello World";

        String result = recommendationService.removeHtmlFormatting(input);

        assertEquals(expected, result);
    }

    @Test
    void recommendStory_Successful() throws Exception {
        // Given
        User user = User.builder()
                .username("testUser")
                .build();
        user.setId(1L);
        // Set necessary properties
        Set<Long> excludedLikedIds = new HashSet<>(); // Example set
        String mockResponse = "{\"ids\": [1, 2, 3]}";

        when(restTemplate.postForEntity(eq("http://example.com/recommend-story"), any(), eq(String.class)))
                .thenReturn(ResponseEntity.ok(mockResponse));

        // When
        Set<Long> result = recommendationService.recommendStory(user, excludedLikedIds);

        // Then
        assertNotNull(result);
        assertEquals(3, result.size());
        assertTrue(result.containsAll(Set.of(1L, 2L, 3L)));
    }




}
