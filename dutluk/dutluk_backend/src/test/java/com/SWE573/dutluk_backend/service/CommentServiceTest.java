package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Comment;
import com.SWE573.dutluk_backend.model.Story;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.CommentRepository;
import com.SWE573.dutluk_backend.request.CommentRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.HashSet;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CommentServiceTest {
    @Mock
    private CommentRepository commentRepository;
    @InjectMocks
    private CommentService commentService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testCreateComment() {

        CommentRequest commentRequest = new CommentRequest();
        commentRequest.setCommentText("comment");
        commentRequest.setStoryId(1L);
        User user1 = User.builder()
                .email("test@example.com")
                .username("User1")
                .password("password")
                .build();
        user1.setId(1L);
        Story story1 = Story.builder()
                .title("Story 1")
                .text("text")
                .user(user1)
                .build();
        story1.setId(1L);
        Comment expectedComment = Comment.builder()
                .text("This is a comment")
                .story(story1)
                .user(user1)
                .likes(new HashSet<>())
                .build();

        when(commentRepository.save(any(Comment.class))).thenReturn(expectedComment);


        Comment createdComment = commentService.createComment(commentRequest, user1, story1);


        verify(commentRepository, times(1)).save(any(Comment.class));


        assertNotNull(createdComment);
        assertEquals("This is a comment", createdComment.getText());
        assertEquals(story1, createdComment.getStory());
        assertEquals(user1, createdComment.getUser());
        assertTrue(createdComment.getLikes().isEmpty());
    }

    @Test
    void testLikeComment_ExistingCommentId() {

        Long userId = 1L;
        Comment existingComment = Comment.builder()
                .likes(new HashSet<>())
                .build();
        existingComment.setId(1L);
        when(commentRepository.findById(existingComment.getId())).thenReturn(Optional.of(existingComment));
        when(commentRepository.save(any(Comment.class))).thenReturn(existingComment);


        Comment likedComment = commentService.likeComment(existingComment.getId(), userId);


        verify(commentRepository, times(1)).findById(existingComment.getId());
        verify(commentRepository, times(1)).save(any(Comment.class));


        assertNotNull(likedComment);
        assertEquals(existingComment, likedComment);
        assertTrue(likedComment.getLikes().contains(userId));
    }

    @Test
    void testLikeComment_NonExistingCommentId() {
        Long commentId = 1L;
        Long userId = 1L;
        when(commentRepository.findById(commentId)).thenReturn(Optional.empty());
        assertThrows(NoSuchElementException.class, () -> commentService.likeComment(commentId, userId));

        verify(commentRepository, times(1)).findById(commentId);
        verify(commentRepository, never()).save(any(Comment.class));
    }
}
