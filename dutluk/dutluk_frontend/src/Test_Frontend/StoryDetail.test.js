import React from 'react';
import { render, fireEvent, waitFor, screen } from '@testing-library/react';
import axios from 'axios';
import StoryDetails from '../components/StoryDetails'; 
import { MemoryRouter, Routes, Route } from 'react-router-dom';

jest.mock('axios');

const mockedStory = {
  id: '1',
  title: 'Test Story',
  text: '<p>Test Story Content</p>',
  likes: [],
  labels: [],
  user: { id: 'user1', username: 'testuser' },
  comments: [],
  locations: [{ id: 'loc1', latitude: 0, longitude: 0, locationName: 'Test Location' }],
  // Add other necessary fields
};

describe('StoryDetails Component', () => {
  beforeEach(() => {
    axios.get.mockResolvedValue({ data: mockedStory });
  });

  test('renders and fetches story details', async () => {
    render(
      <MemoryRouter initialEntries={['/story/1']}>
        <Routes>
          <Route path="/story/:id" element={<StoryDetails />} />
        </Routes>
      </MemoryRouter>
    );

    await waitFor(() => {
      expect(screen.getByRole('heading', { name: /Test Story/i })).toBeInTheDocument();
    });
  });

  test('allows submitting a comment', async () => {
    render(
      <MemoryRouter initialEntries={['/story/1']}>
        <Routes>
          <Route path="/story/:id" element={<StoryDetails />} />
        </Routes>
      </MemoryRouter>
    );

    
    await waitFor(() => {
      expect(screen.getByRole('heading', { name: /Test Story/i })).toBeInTheDocument();
    });

    const commentTextArea = screen.getByPlaceholderText(/Add Comment/i);
    fireEvent.change(commentTextArea, { target: { value: 'New Comment' } });

    const submitButton = screen.getByRole('button', { name: /Submit/i });
    axios.post.mockResolvedValue({ data: { /* response data */ } });
    fireEvent.click(submitButton);

   
  });

  
});
