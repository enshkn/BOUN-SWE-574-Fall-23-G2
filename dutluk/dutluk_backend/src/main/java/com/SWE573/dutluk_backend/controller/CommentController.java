package com.SWE573.dutluk_backend.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/comment")
@CrossOrigin(origins = "http://localhost:3000", allowCredentials = "true")
public class CommentController {
}
