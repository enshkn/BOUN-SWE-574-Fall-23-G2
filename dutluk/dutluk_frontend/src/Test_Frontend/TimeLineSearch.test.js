import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react';
import TimelineSearch from '../components/TimelineSearch';
import axios from 'axios';


jest.mock('axios');


const mockGeolocation = {
  getCurrentPosition: jest.fn().mockImplementation((success) => Promise.resolve(success({
    coords: {
      latitude: 35,
      longitude: 139
    }
  })))
};
global.navigator.geolocation = mockGeolocation;

describe('TimelineSearch Component', () => {
  it('renders without crashing', () => {
    render(<TimelineSearch />);
  });

  it('handles state changes for input fields', () => {
    const { getByLabelText } = render(<TimelineSearch />);
    const radiusInput = getByLabelText(/Radius/i);
    fireEvent.change(radiusInput, { target: { value: '10' } });
    expect(radiusInput.value).toBe('10');
  });

  it('makes an API call on search and handles the response', async () => {
    const mockData = { data: [{ id: 1, title: 'Test Story' }] };
    axios.get.mockResolvedValue(mockData);

    const { getByText } = render(<TimelineSearch />);
    

  
  });

  it('handles geolocation and sets user location', async () => {
    const { getByText } = render(<TimelineSearch />);
    const locationButton = getByText(/Use My Location/i);
    fireEvent.click(locationButton);

    await waitFor(() => {
      expect(mockGeolocation.getCurrentPosition).toHaveBeenCalled();

    });
  });

});
