package com.SWE573.dutluk_backend.repository;

import com.SWE573.dutluk_backend.model.Comment;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommentRepository extends CrudRepository<Comment, Long> {
    List<Comment> findAllByStoryId(Long storyId);

    Comment getCommentById(Long commentId);
}
