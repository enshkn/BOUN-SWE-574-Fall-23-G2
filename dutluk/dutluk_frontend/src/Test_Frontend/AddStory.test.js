import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react';
import axios from 'axios';
import { MemoryRouter } from 'react-router-dom';
import AddStory from '../components/AddStory';


jest.mock('axios');

describe('AddStory Component', () => {
  beforeEach(() => {

    axios.post.mockResolvedValue({ data: { id: '123', message: 'Story added successfully!' } });
    
   
    process.env.REACT_APP_BACKEND_URL = 'http://localhost:3000';
  });

  it('renders the component correctly', () => {
    const { getByText } = render(
      <MemoryRouter>
        <AddStory />
      </MemoryRouter>
    );
    expect(getByText(/Add Story/i)).toBeInTheDocument();
  });

  it('submits the story form correctly', async () => {
    const { getByLabelText, getByRole } = render(
      <MemoryRouter>
        <AddStory />
      </MemoryRouter>
    );

   
    fireEvent.change(getByLabelText(/Title:/i), { target: { value: 'My New Story' } });
    

    fireEvent.click(getByRole('button', { name: /Add Story/i }));

    await waitFor(() => {
    
      
    });
  });


});
