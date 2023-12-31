import React from 'react';
import { render, fireEvent, screen } from '@testing-library/react';
import axios from 'axios';
import StorySearch from '../components/StorySearch'; 

jest.mock('axios');

describe('StorySearch Component', () => {
  test('renders StorySearch component', () => {
    render(<StorySearch />);
    expect(screen.getByLabelText(/Explore Query:/i)).toBeInTheDocument();
  });

  test('allows the user to enter a search query', () => {
    render(<StorySearch />);
    const input = screen.getByLabelText(/Explore Query:/i);

    fireEvent.change(input, { target: { value: 'test query' } });
    expect(input.value).toBe('test query');
  });

  test('handles the search button click', () => {
    render(<StorySearch />);
    
    const button = screen.getByRole('button', { name: /Explore/i });
    axios.get.mockResolvedValue({ data: [] });
    fireEvent.click(button);
    
  });

  
});
