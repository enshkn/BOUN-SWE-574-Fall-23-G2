package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.repository.UserRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.service.StoryService;
import com.SWE573.dutluk_backend.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.text.ParseException;
import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class StoryServiceTest {
    @Mock
    private StoryRepository storyRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserService userService;
    @InjectMocks
    private StoryService storyService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testCreateStory() throws ParseException {
        User foundUser = User.builder()
                .username("testUser")
                .build();
        when(userService.findByUserId(1L)).thenReturn(foundUser);

        // Create a StoryCreateRequest
        StoryCreateRequest storyCreateRequest = new StoryCreateRequest();
        ArrayList<String> labels = new ArrayList<>();
        labels.add("label1");
        labels.add("label2");
        storyCreateRequest.setTitle("Test Story");
        storyCreateRequest.setLabels(labels);
        storyCreateRequest.setText("Test story text");
        storyCreateRequest.setStartTimeStamp(LocalDate.now());
        storyCreateRequest.setEndTimeStamp(LocalDate.now());
        storyCreateRequest.setSeason("Summer");
        storyCreateRequest.setDecade("2020s");
        List<Location> locations = new ArrayList<>();
        locations.add(Location.builder()
                .latitude(41.085064)
                .longitude(29.044687)
                .locationName("Istanbul")
                .build());
        storyCreateRequest.setLocations((ArrayList<Location>) locations);

        // Mock the StoryRepository to return the saved Story
        Story savedStory = Story.builder()
                .title("Test Story")
                .labels(Arrays.asList("label1", "label2"))
                .text("Test story text")
                .startTimeStamp(LocalDate.now())
                .endTimeStamp(LocalDate.now())
                .season("Summer")
                .user(foundUser)
                .decade("2010s")
                .createdAt(new Date())
                .likes(new HashSet<>())
                .locations(locations)
                .build();
        when(storyRepository.save(any(Story.class))).thenReturn(savedStory);

        // Call the createStory method
        Story createdStory = storyService.createStory(userService.findByUserId(1L), storyCreateRequest);

        // Verify the UserService and StoryRepository interactions
        verify(userService, times(1)).findByUserId(1L);
        verify(storyRepository, times(1)).save(any(Story.class));

        // Verify the createdStory object
        assertNotNull(createdStory);
        assertEquals("Test Story", createdStory.getTitle());
        assertEquals(Arrays.asList("label1", "label2"), createdStory.getLabels());
        assertEquals("Test story text", createdStory.getText());
        assertEquals(LocalDate.now(), createdStory.getStartTimeStamp());
        assertEquals(LocalDate.now(), createdStory.getEndTimeStamp());
        assertEquals("Summer", createdStory.getSeason());
        assertEquals("2010s", createdStory.getDecade());
        assertEquals(foundUser, createdStory.getUser());
        assertEquals(locations, createdStory.getLocations());
    }

    @Test
    void testGetStoryByStoryId() {
        // Mock the StoryRepository to return a Story
        Story story = Story.builder()
                .title("Test Story")
                .build();
        when(storyRepository.findById(1L)).thenReturn(Optional.of(story));

        // Call the getStoryByStoryId method
        Story retrievedStory = storyService.getStoryByStoryId(1L);

        // Verify the StoryRepository interaction
        verify(storyRepository, times(1)).findById(1L);

        // Verify the retrievedStory object
        assertNotNull(retrievedStory);
        assertEquals("Test Story", retrievedStory.getTitle());
    }

    @Test
    void testFindAllStoriesByUserId() {
        // Prepare the test data
        User foundUser = User.builder()
                .email("test@example.com")
                .username("testUser")
                .password("password")
                .build();

        Story story1 = Story.builder()
                .title("Story 1")
                .text("text")
                .user(foundUser)
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .text("text")
                .user(foundUser)
                .build();

        // Mock the dependencies
        when(storyRepository.findByUserId(1L)).thenReturn(Arrays.asList(story1, story2));

        // Execute the method
        List<Story> stories = storyService.findAllStoriesByUserId(1L);

        // Verify the interactions
        verify(storyRepository, times(1)).findByUserId(1L);

        // Verify the result
        assertNotNull(stories);
        assertEquals(2, stories.size());
        assertEquals("Story 1", stories.get(0).getTitle());
        assertEquals("Story 2", stories.get(1).getTitle());
    }
    @Test
    void testFindFollowingStories() {
        // Prepare the test data
        User user1 = User.builder()
                .email("test@example.com")
                .username("User1")
                .password("password")
                .build();
        user1.setId(1L);
        User user2 = User.builder()
                .email("test2@example.com")
                .username("User2")
                .password("password")
                .followers(new HashSet<>(Collections.singletonList(user1)))
                .build();
        user2.setId(2L);
        User user3 = User.builder()
                .email("test3@example.com")
                .username("User3")
                .password("password")
                .followers(new HashSet<>(Collections.singletonList(user1)))
                .build();
        user3.setId(3L);
        Story story1 = Story.builder()
                .title("Story 1")
                .text("text")
                .user(user1)
                .build();
        story1.setId(1L);
        Story story2 = Story.builder()
                .title("Story 2")
                .text("text")
                .user(user2)
                .build();
        story2.setId(2L);
        Story story3 = Story.builder()
                .title("Story 3")
                .text("text")
                .user(user3)
                .build();
        story3.setId(3L);
        // Mock the dependencies
        when(storyRepository.findByUserId(1L)).thenReturn(Collections.singletonList(story1));
        when(storyRepository.findByUserId(2L)).thenReturn(Collections.singletonList(story2));
        when(storyRepository.findByUserId(3L)).thenReturn(Collections.singletonList(story3));

        // Prepare the user with following relationships
        User foundUser = User.builder()
                .email("test4@email.com")
                .username("TestUser")
                .password("password")
                .following(new HashSet<>(Arrays.asList(user2, user3)))
                .build();

        // Execute the method
        List<Story> followingStories = storyService.findFollowingStories(foundUser);

        // Verify the interactions
        verify(storyRepository, times(1)).findByUserId(2L);
        verify(storyRepository, times(1)).findByUserId(3L);

        // Verify the result
        assertNotNull(followingStories);
        assertEquals(2, followingStories.size());
        assertTrue(followingStories.stream().anyMatch(story -> story.getTitle().equals("Story 2")));
        assertTrue(followingStories.stream().anyMatch(story -> story.getTitle().equals("Story 3")));
    }



    @Test
    void testLikeStory() {
        // Prepare the test data
        Story story = Story.builder()
                .title("Test Story")
                .text("text")
                .likes(new HashSet<>(Arrays.asList(1L, 2L)))
                .build();
        story.setId(1L);
        // Mock the dependencies
        when(storyRepository.findById(1L)).thenReturn(Optional.of(story));
        when(storyRepository.save(any(Story.class))).thenReturn(story);

        // Execute the method
        Story likedStory = storyService.likeStory(1L, 3L);

        // Verify the interactions
        verify(storyRepository, times(1)).findById(1L);
        verify(storyRepository, times(1)).save(any(Story.class));

        // Verify the result
        assertNotNull(likedStory);
        assertEquals(3, likedStory.getLikes().size());
        assertTrue(likedStory.getLikes().contains(1L));
        assertTrue(likedStory.getLikes().contains(2L));
        assertTrue(likedStory.getLikes().contains(3L));
    }

    @Test
    void testSearchStoriesWithLocation() {
        // Prepare the test data
        String query = "marvel";
        int radius = 10;
        Double latitude = 41.085064;
        Double longitude = 29.044687;
        Location location1 = Location.builder()
                .latitude(latitude)
                .longitude(longitude)
                .locationName("Istanbul")
                .build();
        location1.setId(1L);
        Story story1 = Story.builder()
                .title("Story of a marvel")
                .text("text")
                .locations(Arrays.asList(location1))
                .build();
        story1.setId(1L);
        Story story2 = Story.builder()
                .title("Story 2")
                .text("text")
                .locations(Arrays.asList(
                        Location.builder()
                                .latitude(41.100000)
                                .longitude(29.050000)
                                .locationName("Izmir")
                                .build()
                ))
                .build();
        story2.setId(2L);
        // Mock the dependencies
        when(storyRepository.findByTitleContainingIgnoreCaseAndLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                query, 40.99497390990991, 41.175154090090096, 28.925162071447236, 29.164211928552763
        )).thenReturn(Collections.singletonList(story1));

        // Execute the method
        List<Story> searchResults = storyService.searchStoriesWithLocation(query, radius, latitude, longitude);

        // Verify the interactions
        verify(storyRepository, times(1)).findByTitleContainingIgnoreCaseAndLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                query, 40.99497390990991, 41.175154090090096, 28.925162071447236, 29.164211928552763
        );

        // Verify the result
        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story of a marvel", searchResults.get(0).getTitle());
    }


    @Test
    void testSearchStoriesWithQuery() {
        // Prepare the test data
        String query = "Test";

        Story story1 = Story.builder()
                .title("Test Story 1")
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .labels(Arrays.asList("Test Label", "Label 2"))
                .build();

        // Mock the dependencies
        when(storyRepository.findByTitleContainingIgnoreCase(query)).thenReturn(Collections.singletonList(story1));
        when(storyRepository.findByLabelsContainingIgnoreCase(query)).thenReturn(Collections.singletonList(story2));

        // Execute the method
        Set<Story> searchResults = storyService.searchStoriesWithQuery(query);

        // Verify the interactions
        verify(storyRepository, times(1)).findByTitleContainingIgnoreCase(query);
        verify(storyRepository, times(1)).findByLabelsContainingIgnoreCase(query);

        // Verify the result
        assertNotNull(searchResults);
        assertEquals(2, searchResults.size());
        assertTrue(searchResults.contains(story1));
        assertTrue(searchResults.contains(story2));
    }

    @Test
    void testSearchStoriesWithDecade() {
        // Prepare the test data
        String decade = "2010s";

        Story story1 = Story.builder()
                .title("Story 1")
                .decade("2010s")
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .decade("2010s")
                .build();

        // Mock the dependencies
        when(storyRepository.findByDecadeContainingIgnoreCase(decade)).thenReturn(Collections.singletonList(story1));

        // Execute the method
        List<Story> searchResults = storyService.searchStoriesWithDecade(decade);

        // Verify the interactions
        verify(storyRepository, times(1)).findByDecadeContainingIgnoreCase(decade);

        // Verify the result
        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

    @Test
    void testSearchStoriesWithSeason() {
        // Prepare the test data
        String season = "Summer";

        Story story1 = Story.builder()
                .title("Story 1")
                .season("Summer")
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .season("Spring")
                .build();

        // Mock the dependencies
        when(storyRepository.findByDecadeContainingIgnoreCase(season)).thenReturn(Collections.singletonList(story1));

        // Execute the method
        List<Story> searchResults = storyService.searchStoriesWithSeason(season);

        // Verify the interactions
        verify(storyRepository, times(1)).findByDecadeContainingIgnoreCase(season);

        // Verify the result
        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

    @Test
    void testSearchStoriesWithSingleDate() {
        // Prepare the test data
        LocalDate startTimeStamp = LocalDate.now();

        Story story1 = Story.builder()
                .title("Story 1")
                .startTimeStamp(startTimeStamp)
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .startTimeStamp(startTimeStamp.plusDays(1))
                .build();

        // Mock the dependencies
        when(storyRepository.findByStartTimeStamp(startTimeStamp)).thenReturn(Collections.singletonList(story1));

        // Execute the method
        List<Story> searchResults = storyService.searchStoriesWithSingleDate(startTimeStamp);

        // Verify the interactions
        verify(storyRepository, times(1)).findByStartTimeStamp(startTimeStamp);

        // Verify the result
        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

    @Test
    void testSearchStoriesWithMultipleDate() {
        // Prepare the test data
        LocalDate startTimeStamp = LocalDate.now();
        LocalDate endTimeStamp = LocalDate.now().plusDays(5);

        Story story1 = Story.builder()
                .title("Story 1")
                .startTimeStamp(startTimeStamp)
                .endTimeStamp(endTimeStamp)
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .startTimeStamp(startTimeStamp.plusDays(1))
                .endTimeStamp(endTimeStamp.plusDays(1))
                .build();

        // Mock the dependencies
        when(storyRepository.findByStartTimeStampBetween(startTimeStamp, endTimeStamp)).thenReturn(Collections.singletonList(story1));

        // Execute the method
        List<Story> searchResults = storyService.searchStoriesWithMultipleDate(startTimeStamp, endTimeStamp);

        // Verify the interactions
        verify(storyRepository, times(1)).findByStartTimeStampBetween(startTimeStamp, endTimeStamp);

        // Verify the result
        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

}
