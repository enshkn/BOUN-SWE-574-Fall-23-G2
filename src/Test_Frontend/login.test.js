import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react';
import axios from 'axios';
import { MemoryRouter } from "react-router-dom";
import LoginComponent from "../components/Login"; 

jest.mock('axios');

describe('LoginComponent', () => {
  it('submits the login form correctly', async () => {
    const mockNavigate = jest.fn();
    jest.mock('react-router-dom', () => ({
      ...jest.requireActual('react-router-dom'),
      useNavigate: () => mockNavigate,
    }));

    const { getByLabelText, getByRole } = render(
      <MemoryRouter>
        <LoginComponent/>
      </MemoryRouter>
    );

    
    fireEvent.change(getByLabelText(/Username or Email:/i), { target: { value: 'test' } });
    fireEvent.change(getByLabelText(/Password:/i), { target: { value: '123' } });

    axios.post.mockResolvedValue({ data: { message: 'Logged in successfully!' } });

    fireEvent.click(getByRole('button', { name: /Log in/i }));

    await waitFor(() => {
      expect(axios.post).toHaveBeenCalledWith(`${process.env.REACT_APP_BACKEND_URL}/api/user/login`, {
        identifier: 'test',
        password: '123'
      }, { withCredentials: true });

    });
  });

 
});
