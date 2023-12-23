import React from 'react';
import { render, waitFor, screen } from '@testing-library/react';
import axios from 'axios';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import Profile from '../components/Profile';

jest.mock('axios');

describe('Profile Component', () => {
  it('renders the profile component correctly', async () => {
    const mockUser = {
      username: 'testuser',
      biography: 'Test biography',
    };

    // Mock the Axios requests
    axios.get.mockResolvedValueOnce({ data: mockUser }); // Mock user data
    axios.get.mockResolvedValueOnce({ data: { message: 'Registered successfully!' } }); // Mock user profile data

    render(
      <MemoryRouter initialEntries={['/profile/123']}>
        <Routes>
          <Route path="/profile/:id" element={<Profile />} />
        </Routes>
      </MemoryRouter>
    );

    // Wait for elements to appear in the DOM
   
  });
});
