import React from 'react';
import { render, waitFor, screen } from '@testing-library/react';
import axios from 'axios';
import AllStories from '../components/AllStories';
import { BrowserRouter as Router } from 'react-router-dom';

// Mock axios
jest.mock('axios');

describe('AllStories Component', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    axios.get.mockResolvedValue({ data: [] }); // Default mock response
  });

  const renderWithRouter = (component) => {
    return {
      ...render(<Router>{component}</Router>),
    };
  };

  it('renders without crashing', async () => {
    renderWithRouter(<AllStories />);
    await waitFor(() => {
      expect(screen.getByText(/All Stories/)).toBeInTheDocument();
    });
  });

  it('displays stories when API call is successful', async () => {
    axios.get.mockResolvedValue({
      data: [{ id: 1, title: 'Story 1' }, { id: 2, title: 'Story 2' }]
    });

    renderWithRouter(<AllStories />);


  });

  it('displays an error message when API call fails', async () => {
    axios.get.mockRejectedValue(new Error('Failed to load stories'));

    renderWithRouter(<AllStories />);

    await waitFor(() => {
      expect(screen.getByText('Error occured while loading stories')).toBeInTheDocument();
    });
  });

  // Add more tests as needed
});
