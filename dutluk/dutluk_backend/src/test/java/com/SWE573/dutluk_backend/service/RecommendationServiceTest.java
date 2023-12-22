package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

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
    void vectorizeRequest_Successful() throws Exception {
        // Arrange
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

        String expectedResponse = "Data sent to karadut";

        // Act
        CompletableFuture<String> resultFuture = recommendationService.vectorizeRequest(savedStory);

        // Wait for the asynchronous operation to complete and then get the result
        String actualResponse = resultFuture.get(); // This blocks the thread until the future is complete

        // Now compare the actual result with the expected result
        assertEquals(expectedResponse, actualResponse);
    }


    @Test
    void vectorizeEditRequest_Successful() throws ExecutionException, InterruptedException {
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

        String expectedResponse = "Data sent to karadut";

        // Act
        CompletableFuture<String> resultFuture = recommendationService.vectorizeEditRequest(savedStory);

        // Wait for the asynchronous operation to complete and then get the result
        String actualResponse = resultFuture.get(); // This blocks the thread until the future is complete

        // Now compare the actual result with the expected result
        assertEquals(expectedResponse, actualResponse);
    }

    @Test
    void likedStory_Successful() throws Exception {
        // Arrange
        User foundUser = User.builder()
                .username("testUser")
                .build();
        foundUser.setId(1L);

        Story savedStory = Story.builder()
                .title("title")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .user(foundUser)
                .build();
        savedStory.setId(1L);

        Integer likedStorySize = 5;
        String expectedResponse = "Recommendation complete";

        // Act
        CompletableFuture<String> resultFuture = recommendationService.likedStory(savedStory, foundUser, likedStorySize);

        // Assert
        // Wait for the asynchronous operation to complete and then get the result
        String actualResponse = resultFuture.get(); // This blocks the thread until the future is complete

        // Now compare the actual result with the expected result
        assertEquals(expectedResponse, actualResponse);
    }

    @Test
    void dislikedStory_Successful() throws JsonProcessingException, ExecutionException, InterruptedException {

        // Arrange
        User foundUser = User.builder()
                .username("testUser")
                .build();
        foundUser.setId(1L);

        Story savedStory = Story.builder()
                .title("title")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .user(foundUser)
                .build();
        savedStory.setId(1L);

        Integer likedStorySize = 5;
        String expectedResponse = "Recommendation complete";

        // Act
        CompletableFuture<String> resultFuture = recommendationService.likedStory(savedStory, foundUser, likedStorySize);

        // Assert
        // Wait for the asynchronous operation to complete and then get the result
        String actualResponse = resultFuture.get(); // This blocks the thread until the future is complete

        // Now compare the actual result with the expected result
        assertEquals(expectedResponse, actualResponse);
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
        String mockResponse = "{\"ids\": [1, 2, 3], \"scores\": [0.5, 0.75, 1.0]}"; // Include scores in mock response

        when(restTemplate.postForEntity(eq("http://example.com/recommend-story"), any(), eq(String.class)))
                .thenReturn(ResponseEntity.ok(mockResponse));

        // When
        Map<Long, Integer> result = recommendationService.recommendStory(user);

        // Then
        assertNotNull(result);
        assertEquals(3, result.size());
        assertTrue(result.containsKey(1L));
        assertTrue(result.containsKey(2L));
        assertTrue(result.containsKey(3L));
        assertEquals("50%", result.get(1L)); // Check if the values are correctly formatted as percentage strings
        assertEquals("75%", result.get(2L));
        assertEquals("100%", result.get(3L));
    }





}
