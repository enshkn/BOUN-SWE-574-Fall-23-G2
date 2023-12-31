import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react';
import axios from 'axios';
import { MemoryRouter } from "react-router-dom";
import Register from "../components/Register"; 

jest.mock('axios');

describe('RegisterComponent', () => {
  it('submits the registration form correctly', async () => {
    const mockNavigate = jest.fn();
    jest.mock('react-router-dom', () => ({
      ...jest.requireActual('react-router-dom'),
      useNavigate: () => mockNavigate,
    }));

    
    const { getByTestId, getByRole } = render(
      <MemoryRouter >
        <Register/>
      </MemoryRouter >
    );



    fireEvent.change(getByTestId('email-input'), { target: { value: 'test@example.com' } });
    fireEvent.change(getByTestId('username-input'), { target: { value: 'testuser' } });
    fireEvent.change(getByTestId('password-input'), { target: { value: 'password123' } });
    fireEvent.change(getByTestId('retype-password-input'), { target: { value: 'password123' } });

  

    
    axios.post.mockResolvedValue({ data: { message: 'Registered successfully!' } });

    
    fireEvent.click(getByRole('button', { name: /Register/i }));


    await waitFor(() => {
      
      expect(axios.post).toHaveBeenCalledWith(`${process.env.REACT_APP_BACKEND_URL}/api/user/register`, {
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123'
      });
    });
  });

 
});
