import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react';
const  axios =  require('axios') // You may need to mock axios
//import { BrowserRouter } from 'react-router-dom';
import Register from './Register'; // Import your component

jest.mock('axios'); // Mock axios calls

describe('Register', () => {
  it('should render without errors', () => {
    const { getByText, getByLabelText } = render(
      <BrowserRouter>
        <RegisterComponent />
      </BrowserRouter>
    );

  
    expect(getByText('Register')).toBeInTheDocument();
    expect(getByLabelText('Email:')).toBeInTheDocument();
    expect(getByLabelText('Username:')).toBeInTheDocument();
    expect(getByLabelText('Password:')).toBeInTheDocument();
    expect(getByLabelText('Retype Password:')).toBeInTheDocument();
    expect(getByText('Register')).toBeInTheDocument();
  });

  
  it('should submit registration form successfully', async () => {
    axios.post.mockResolvedValueOnce({ data: 'Registration success' });

    const { getByLabelText, getByText } = render(
      <BrowserRouter>
        <RegisterComponent />
      </BrowserRouter>
    );

    const emailInput = getByLabelText('Email:');
    const usernameInput = getByLabelText('Username:');
    const passwordInput = getByLabelText('Password:');
    const retypePasswordInput = getByLabelText('Retype Password:');
    const registerButton = getByText('Register');

    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.change(usernameInput, { target: { value: 'testuser' } });
    fireEvent.change(passwordInput, { target: { value: 'password123' } });
    fireEvent.change(retypePasswordInput, { target: { value: 'password123' } });

    fireEvent.click(registerButton);

    
    await waitFor(() => {
      expect(axios.post).toHaveBeenCalledWith(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/register`,
        {
          email: 'test@example.com',
          username: 'testuser',
          password: 'password123',
        }
      );
      expect(getByText('Registered successfully!')).toBeInTheDocument();
    });
  });

  it('should handle registration failure', async () => {
    axios.post.mockRejectedValueOnce(new Error('Registration error'));

    const { getByLabelText, getByText } = render(
      <BrowserRouter>
        <RegisterComponent />
      </BrowserRouter>
    );

    const emailInput = getByLabelText('Email:');
    const usernameInput = getByLabelText('Username:');
    const passwordInput = getByLabelText('Password:');
    const retypePasswordInput = getByLabelText('Retype Password:');
    const registerButton = getByText('Register');

 
    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.change(usernameInput, { target: { value: 'testuser' } });
    fireEvent.change(passwordInput, { target: { value: 'password123' } });
    fireEvent.change(retypePasswordInput, { target: { value: 'password123' } });

    fireEvent.click(registerButton);

    await waitFor(() => {
      expect(axios.post).toHaveBeenCalledWith(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/register`,
        {
          email: 'test@example.com',
          username: 'testuser',
          password: 'password123',
        }
      );
      expect(getByText('Error occurred during registration!')).toBeInTheDocument();
    });
  });
});
