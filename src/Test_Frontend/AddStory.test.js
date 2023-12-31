import React from 'react';
import { render, fireEvent, waitFor, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import axios from 'axios';
import AddStory from '../components/AddStory';


jest.mock('axios');

describe('AddStoryForm', () => {
    
    it('renders the component with default state', () => {
        render(
            <MemoryRouter>
                <AddStory />
            </MemoryRouter>
        );
        expect(screen.getByText(/Select Location Type/)).toBeInTheDocument();
        
        expect(screen.getByLabelText('Title:')).toBeInTheDocument();
    });

    
    it('allows user to enter a title', () => {
        render(
            <MemoryRouter>
                <AddStory />
            </MemoryRouter>
        );
        const titleInput = screen.getByLabelText('Title:');
        fireEvent.change(titleInput, { target: { value: 'My Story Title' } });
        expect(titleInput.value).toBe('My Story Title');
    });

    
    it('submits the form with entered data', async () => {
        const mockResponse = { data: { id: 1 } };
        axios.post.mockResolvedValue(mockResponse);

        render(
            <MemoryRouter>
                <AddStory />
            </MemoryRouter>
        );

        
        const titleInput = screen.getByLabelText('Title:');
        fireEvent.change(titleInput, { target: { value: 'My Story Title' } });

        
        const submitButton = screen.getByRole('button', { name: /Add Story/i });
        fireEvent.click(submitButton);

        await waitFor(() => {
            
                `${process.env.REACT_APP_BACKEND_URL}/api/story/add`,
                expect.anything() 
            
        });
    });
});
