import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import MockAdapter from 'axios-mock-adapter';
import axios from 'axios';
import FollowedUserStories from '../components/FollowedUserStories'; // adjust the path as needed

describe('FollowedUserStories', () => {
  let mock;

  beforeEach(() => {
    mock = new MockAdapter(axios);
  });

  afterEach(() => {
    mock.restore();
  });

  it('renders without crashing', () => {
    render(<FollowedUserStories />);
    expect(screen.getByText('Story Feed')).toBeInTheDocument();
  });

  it('displays stories when request succeeds', async () => {
    const stories = [
      { id: '1', title: 'Story 1', content: 'Content 1' },
      { id: '2', title: 'Story 2', content: 'Content 2' }
    ];

    mock.onGet(`${process.env.REACT_APP_BACKEND_URL}/api/story/following`).reply(200, stories);

    render(<FollowedUserStories />);

  });

  it('displays error message when request fails', async () => {
    mock.onGet(`${process.env.REACT_APP_BACKEND_URL}/api/story/following`).networkError();

    render(<FollowedUserStories />);
    await waitFor(() => {
      expect(screen.getByText('Error occured while loading stories from followings!')).toBeInTheDocument();
    });
  });
});
