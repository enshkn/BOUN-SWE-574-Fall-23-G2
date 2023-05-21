package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.configuration.JwtUtil;
import com.SWE573.dutluk_backend.model.User;
import com.SWE573.dutluk_backend.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.security.auth.login.AccountNotFoundException;
import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private JwtUtil jwtUtil;

    @InjectMocks
    private UserService userService;



    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testAddUser() {
        // Prepare
        User user = new User();
        when(userRepository.save(user)).thenReturn(user);

        // Execute
        User savedUser = userService.addUser(user);

        // Verify
        assertEquals(user, savedUser);
        verify(userRepository, times(1)).save(user);
    }

    @Test
    void testValidateTokenizedUser() {
        // Prepare
        HttpServletRequest request = mock(HttpServletRequest.class);
        Cookie cookie = mock(Cookie.class);
        when(request.getCookies()).thenReturn(new Cookie[]{cookie});
        String token = "testToken";
        when(cookie.getName()).thenReturn("Bearer");
        when(cookie.getValue()).thenReturn(token);
        when(jwtUtil.extractId(token)).thenReturn(1L);
        when(userRepository.findById(1L)).thenReturn(Optional.empty()); // Mocking an empty optional

        // Execute
        assertThrows(NoSuchElementException.class, () -> userService.validateTokenizedUser(request));

        // Verify
        verify(jwtUtil).extractId(token);
        verify(userRepository).findById(1L);
    }



    @Test
    void testFindAll() {
        // Prepare
        List<User> userList = Arrays.asList(new User(), new User());
        when(userRepository.findAll()).thenReturn(userList);

        // Execute
        List<User> result = userService.findAll();

        // Verify
        assertEquals(userList, result);
        verify(userRepository, times(1)).findAll();
    }

    @Test
    void testFindByUserId_existingId() {
        // Prepare
        User user = new User();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        // Execute
        User result = userService.findByUserId(1L);

        // Verify
        assertEquals(user, result);
        verify(userRepository, times(1)).findById(1L);
    }

    @Test
    void testFindByUserId_nonexistentId() {
        // Prepare
        when(userRepository.findById(1L)).thenReturn(Optional.empty());

        // Execute and Verify
        assertThrows(NoSuchElementException.class, () -> userService.findByUserId(1L));
        verify(userRepository, times(1)).findById(1L);
    }

    @Test
    void testFindByUserToken() {
        // Prepare
        String token = "testToken";
        User user = new User();
        when(jwtUtil.extractId(token)).thenReturn(1L);
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        // Execute
        User result = userService.findByUserToken(token);

        // Verify
        assertEquals(user, result);
        verify(jwtUtil, times(1)).extractId(token);
        verify(userRepository, times(1)).findById(1L);
    }

    @Test
    void testFindByUsernameAndPassword_validCredentials() throws AccountNotFoundException {
        String username = "testUser";
        String password = "testPassword";
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        when(userRepository.findByUsername(username)).thenReturn(user);

        // Execute
        User result = userService.findByUsernameAndPassword(username, password);

        // Verify
        assertEquals(user, result);
        verify(userRepository, times(1)).findByUsername(username);
    }

    @Test
    void testFindByUsernameAndPassword_invalidPassword() {
        // Prepare
        String username = "testUser";
        String password = "testPassword";
        User user = new User();
        user.setUsername(username);
        user.setPassword("wrongPassword");
        when(userRepository.findByUsername(username)).thenReturn(user);

        // Execute and Verify
        assertThrows(AccountNotFoundException.class, () -> userService.findByUsernameAndPassword(username, password));
        verify(userRepository, times(1)).findByUsername(username);
    }

    @Test
    void testFindByUsernameAndPassword_userNotFound() {
        // Prepare
        String username = "testUser";
        String password = "testPassword";
        when(userRepository.findByUsername(username)).thenReturn(null);

        // Execute and Verify
        assertThrows(AccountNotFoundException.class, () -> userService.findByUsernameAndPassword(username, password));
        verify(userRepository, times(1)).findByUsername(username);
    }

    @Test
    void testGenerateUserToken() {
        // Prepare
        Long userId = 1L;
        String expectedToken = "testToken";
        when(jwtUtil.generateToken(userId)).thenReturn(expectedToken);
        User user = new User();
        user.setId(userId);

        // Execute
        String result = userService.generateUserToken(user);

        // Verify
        assertEquals(expectedToken, result);
        verify(jwtUtil, times(1)).generateToken(userId);
    }
}