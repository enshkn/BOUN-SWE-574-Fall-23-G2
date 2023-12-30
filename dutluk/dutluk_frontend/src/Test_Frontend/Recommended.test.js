import React from 'react';
import { render, waitFor, screen } from '@testing-library/react';
import { BrowserRouter as Router } from 'react-router-dom';
import axios from 'axios';
import Recommended from '../components/Recommended';


jest.mock('axios');


process.env.REACT_APP_BACKEND_URL = process.env.REACT_APP_BACKEND_URL || 'http://localhost';

describe('Recommended Component', () => {
  const mockStories = [
    { id: 1, title: 'Story 1', content: 'Content 1', text: 'Sample text 1' },
    { id: 2, title: 'Story 2', content: 'Content 2', text: 'Sample text 2' },
    
  ];

  it('renders without crashing', () => {
    axios.get.mockResolvedValue({ data: [] }); 
    render(
      <Router>
        <Recommended />
      </Router>
    );
  });

  it('displays stories when API call is successful', async () => {
    axios.get.mockResolvedValue({ data: mockStories });
    render(
      <Router>
        <Recommended />
      </Router>
    );

    for (const story of mockStories) {
      
    }
  });

  it('displays an error message when API call fails', async () => {
    axios.get.mockRejectedValue(new Error('API call failed'));
    render(
      <Router>
        <Recommended />
      </Router>
    );

    await waitFor(() => {
      expect(screen.getByText('Error occured while loading stories from feed!')).toBeInTheDocument();
    });
  });
});
