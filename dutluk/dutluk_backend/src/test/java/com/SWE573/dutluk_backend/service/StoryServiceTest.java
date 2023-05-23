package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
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


        Story createdStory = storyService.createStory(userService.findByUserId(1L), storyCreateRequest);


        verify(userService, times(1)).findByUserId(1L);
        verify(storyRepository, times(1)).save(any(Story.class));


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

        Story story = Story.builder()
                .title("Test Story")
                .build();
        when(storyRepository.findById(1L)).thenReturn(Optional.of(story));


        Story retrievedStory = storyService.getStoryByStoryId(1L);


        verify(storyRepository, times(1)).findById(1L);


        assertNotNull(retrievedStory);
        assertEquals("Test Story", retrievedStory.getTitle());
    }

    @Test
    void testFindAllStoriesByUserId() {

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


        when(storyRepository.findByUserId(1L)).thenReturn(Arrays.asList(story1, story2));


        List<Story> stories = storyService.findAllStoriesByUserId(1L);


        verify(storyRepository, times(1)).findByUserId(1L);


        assertNotNull(stories);
        assertEquals(2, stories.size());
        assertEquals("Story 1", stories.get(0).getTitle());
        assertEquals("Story 2", stories.get(1).getTitle());
    }
    @Test
    void testFindFollowingStories() {

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

        when(storyRepository.findByUserId(1L)).thenReturn(Collections.singletonList(story1));
        when(storyRepository.findByUserId(2L)).thenReturn(Collections.singletonList(story2));
        when(storyRepository.findByUserId(3L)).thenReturn(Collections.singletonList(story3));


        User foundUser = User.builder()
                .email("test4@email.com")
                .username("TestUser")
                .password("password")
                .following(new HashSet<>(Arrays.asList(user2, user3)))
                .build();


        List<Story> followingStories = storyService.findFollowingStories(foundUser);


        verify(storyRepository, times(1)).findByUserId(2L);
        verify(storyRepository, times(1)).findByUserId(3L);


        assertNotNull(followingStories);
        assertEquals(2, followingStories.size());
        assertTrue(followingStories.stream().anyMatch(story -> story.getTitle().equals("Story 2")));
        assertTrue(followingStories.stream().anyMatch(story -> story.getTitle().equals("Story 3")));
    }



    @Test
    void testLikeStory() {

        Story story = Story.builder()
                .title("Test Story")
                .text("text")
                .likes(new HashSet<>(Arrays.asList(1L, 2L)))
                .build();
        story.setId(1L);

        when(storyRepository.findById(1L)).thenReturn(Optional.of(story));
        when(storyRepository.save(any(Story.class))).thenReturn(story);


        Story likedStory = storyService.likeStory(1L, 3L);


        verify(storyRepository, times(1)).findById(1L);
        verify(storyRepository, times(1)).save(any(Story.class));


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


        List<Story> searchResults = storyService.searchStoriesWithLocation(query, radius, latitude, longitude);


        verify(storyRepository, times(1)).findByTitleContainingIgnoreCaseAndLocations_LatitudeBetweenAndLocations_LongitudeBetween(
                query, 40.99497390990991, 41.175154090090096, 28.925162071447236, 29.164211928552763
        );


        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story of a marvel", searchResults.get(0).getTitle());
    }


    @Test
    void testSearchStoriesWithQuery() {

        String query = "Test";

        Story story1 = Story.builder()
                .title("Test Story 1")
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .labels(Arrays.asList("Test Label", "Label 2"))
                .build();


        when(storyRepository.findByTitleContainingIgnoreCase(query)).thenReturn(Collections.singletonList(story1));
        when(storyRepository.findByLabelsContainingIgnoreCase(query)).thenReturn(Collections.singletonList(story2));


        Set<Story> searchResults = storyService.searchStoriesWithQuery(query);


        verify(storyRepository, times(1)).findByTitleContainingIgnoreCase(query);
        verify(storyRepository, times(1)).findByLabelsContainingIgnoreCase(query);


        assertNotNull(searchResults);
        assertEquals(2, searchResults.size());
        assertTrue(searchResults.contains(story1));
        assertTrue(searchResults.contains(story2));
    }

    @Test
    void testSearchStoriesWithDecade() {

        String decade = "2010s";

        Story story1 = Story.builder()
                .title("Story 1")
                .decade("2010s")
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .decade("2010s")
                .build();


        when(storyRepository.findByDecadeContainingIgnoreCase(decade)).thenReturn(Collections.singletonList(story1));


        List<Story> searchResults = storyService.searchStoriesWithDecade(decade);


        verify(storyRepository, times(1)).findByDecadeContainingIgnoreCase(decade);


        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

    @Test
    void testSearchStoriesWithSeason() {

        String season = "Summer";

        Story story1 = Story.builder()
                .title("Story 1")
                .season("Summer")
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .season("Spring")
                .build();


        when(storyRepository.findBySeasonContainingIgnoreCase(season)).thenReturn(Collections.singletonList(story1));


        List<Story> searchResults = storyService.searchStoriesWithSeason(season);


        verify(storyRepository, times(1)).findBySeasonContainingIgnoreCase(season);


        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

    @Test
    void testSearchStoriesWithSingleDate() {

        LocalDate startTimeStamp = LocalDate.now();

        Story story1 = Story.builder()
                .title("Story 1")
                .startTimeStamp(startTimeStamp)
                .build();

        Story story2 = Story.builder()
                .title("Story 2")
                .startTimeStamp(startTimeStamp.plusDays(1))
                .build();


        when(storyRepository.findByStartTimeStamp(startTimeStamp)).thenReturn(Collections.singletonList(story1));


        List<Story> searchResults = storyService.searchStoriesWithSingleDate(startTimeStamp);


        verify(storyRepository, times(1)).findByStartTimeStamp(startTimeStamp);


        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

    @Test
    void testSearchStoriesWithMultipleDate() {

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


        when(storyRepository.findByStartTimeStampBetween(startTimeStamp, endTimeStamp)).thenReturn(Collections.singletonList(story1));


        List<Story> searchResults = storyService.searchStoriesWithMultipleDate(startTimeStamp, endTimeStamp);


        verify(storyRepository, times(1)).findByStartTimeStampBetween(startTimeStamp, endTimeStamp);


        assertNotNull(searchResults);
        assertEquals(1, searchResults.size());
        assertEquals("Story 1", searchResults.get(0).getTitle());
    }

}
