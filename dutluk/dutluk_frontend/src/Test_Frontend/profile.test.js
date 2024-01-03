import React from 'react';
import { render, waitFor, screen } from '@testing-library/react';
import axios from 'axios';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import Profile from '../components/Profile';

jest.mock('axios');

describe('Profile Component', () => {
  beforeEach(() => {
    axios.get.mockReset();

    axios.get.mockImplementation((url) => {
      if (url.includes('/api/user/isFollowing/')) {
        return Promise.resolve({ data: true });
      }

    
      if (url.includes('/api/user/')) {
        return Promise.resolve({
          data: {
            username: 'testuser',
            biography: 'Test biography',
            profilePhoto: 'test_photo_url'
          }
        });
      }

      if (url.includes('/api/story/fromUserId/')) {
        return Promise.resolve({
          data: [
           
          ]
        });
      }

      return Promise.reject(new Error('not found'));
    });
  });

  it('renders the profile component correctly', async () => {
    render(
      <MemoryRouter initialEntries={['/profile/123']}>
        <Routes>
          <Route path="/profile/:id" element={<Profile />} />
        </Routes>
      </MemoryRouter>
    );

    await waitFor(() => {
      // Verify user information is displayed
      expect(screen.getByText('Username: testuser')).toBeInTheDocument();
      expect(screen.getByText('Biography: Test biography')).toBeInTheDocument();
      expect(screen.getByRole('img', { name: /testuser/i })).toHaveAttribute('src', 'test_photo_url');

      // Verify follow/unfollow button text based on follow status
      expect(screen.getByText('Unfollow')).toBeInTheDocument();


    });
  });

});
