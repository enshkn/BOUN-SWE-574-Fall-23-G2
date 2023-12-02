package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Location;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.StoryRepository;
import com.SWE573.dutluk_backend.request.StoryCreateRequest;
import com.SWE573.dutluk_backend.request.StoryEditRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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

    @Mock
    private RecommendationService recService;

    @Mock
    private ImageService imageService;



    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testCreateStory() throws ParseException, IOException {
        User foundUser = User.builder()
                .username("testUser")
                .build();
        when(userService.findByUserId(1L)).thenReturn(foundUser);
        Date date = new Date();

        StoryCreateRequest storyCreateRequest = new StoryCreateRequest();
        ArrayList<String> labels = new ArrayList<>();
        labels.add("label1");
        labels.add("label2");
        storyCreateRequest.setTitle("Test Story");
        storyCreateRequest.setLabels(labels);
        storyCreateRequest.setText("Test story text");
        storyCreateRequest.setStartTimeStamp(date);
        storyCreateRequest.setEndTimeStamp(date);
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
                .startTimeStamp(date)
                .endTimeStamp(date)
                .season("Summer")
                .user(foundUser)
                .decade("2010s")
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
        assertEquals(date.getTime(), createdStory.getStartTimeStamp().getTime());
        assertEquals(date.getTime(), createdStory.getEndTimeStamp().getTime());
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

        when(storyRepository.findByUserIdOrderByIdDesc(1L)).thenReturn(Collections.singletonList(story1));
        when(storyRepository.findByUserIdOrderByIdDesc(2L)).thenReturn(Collections.singletonList(story2));
        when(storyRepository.findByUserIdOrderByIdDesc(3L)).thenReturn(Collections.singletonList(story3));


        User foundUser = User.builder()
                .email("test4@email.com")
                .username("TestUser")
                .password("password")
                .following(new HashSet<>(Arrays.asList(user2, user3)))
                .build();


        List<Story> followingStories = storyService.findFollowingStories(foundUser);


        verify(storyRepository, times(1)).findByUserIdOrderByIdDesc(2L);
        verify(storyRepository, times(1)).findByUserIdOrderByIdDesc(3L);


        assertNotNull(followingStories);
        assertEquals(2, followingStories.size());
        assertTrue(followingStories.stream().anyMatch(story -> story.getTitle().equals("Story 2")));
        assertTrue(followingStories.stream().anyMatch(story -> story.getTitle().equals("Story 3")));
    }



    @Test
    void testLikeStory() throws JsonProcessingException {

        Story story = Story.builder()
                .title("Test Story")
                .text("text")
                .likes(new HashSet<>())
                .build();
        story.setId(1L);

        User user = User.builder()
                .email("test4@email.com")
                .username("TestUser")
                .password("password")
                .likedStories(new HashSet<>())
                .build();


        when(storyRepository.findById(1L)).thenReturn(Optional.of(story));
        when(storyRepository.save(any(Story.class))).thenAnswer(invocation -> invocation.getArguments()[0]); // Return the same story
        when(userService.findByUserId(user.getId())).thenReturn(user);


        Story likedStory = storyService.likeStory(1L, user.getId());


        verify(storyRepository, times(1)).findById(1L);
        verify(storyRepository, times(1)).save(any(Story.class));
        verify(userService, times(1)).findByUserId(user.getId());


        assertNotNull(likedStory);
        assertEquals(1, likedStory.getLikes().size());
        assertTrue(likedStory.getLikes().contains(user.getId()));
        assertTrue(user.getLikedStories().contains(story.getId()));
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


        List<Story> searchResults = storyService.searchStoriesWithQuery(query);


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
    public void testSearchStoriesWithSingleDate() throws ParseException {

        String startTimeStamp = "2023-01-01";
        Date formattedDate = new SimpleDateFormat("yyyy-MM-dd").parse(startTimeStamp);

        List<Story> expectedStories = new ArrayList<>();
        when(storyRepository.findByStartTimeStamp(formattedDate)).thenReturn(expectedStories);


        List<Story> result = storyService.searchStoriesWithSingleDate(startTimeStamp);


        assertEquals(expectedStories, result);
    }

    @Test
    public void testSearchStoriesWithMultipleDate() throws ParseException {

        String startTimeStamp = "2023-01-01";
        String endTimeStamp = "2023-01-05";

        Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(startTimeStamp);
        Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(endTimeStamp);

        List<Story> expectedStories = new ArrayList<>();
        when(storyRepository.findByStartTimeStampBetween(startDate, endDate)).thenReturn(expectedStories);


        List<Story> result = storyService.searchStoriesWithMultipleDate(startTimeStamp, endTimeStamp);


        assertEquals(expectedStories, result);
    }

    @Test
    public void testEditStory_SuccessfulEdit() throws ParseException, IOException {

        User foundUser = User.builder()
                .username("testUser")
                .build();
        when(userService.findByUserId(1L)).thenReturn(foundUser);
        StoryEditRequest request = new StoryEditRequest();
        Long storyId = 1L;

        Story existingStory = new Story();
        existingStory.setId(storyId);
        existingStory.setUser(foundUser);

        when(storyRepository.findById(storyId)).thenReturn(Optional.of(existingStory));


        Story editedStory = storyService.editStory(request, foundUser, storyId);


        assertNotNull(existingStory);
        assertEquals(storyId, existingStory.getId());
        assertEquals(foundUser, existingStory.getUser());
    }

    @Test
    public void testEditStory_UserMismatch() throws ParseException, IOException {

        User user = new User();
        User anotherUser = new User();
        StoryEditRequest request = new StoryEditRequest();
        Long storyId = 1L;

        Story existingStory = new Story();
        existingStory.setId(storyId);
        existingStory.setUser(anotherUser);

        when(storyRepository.findById(storyId)).thenReturn(Optional.of(existingStory));


        Story editedStory = storyService.editStory(request, user, storyId);


        assertNull(editedStory);
    }

}
