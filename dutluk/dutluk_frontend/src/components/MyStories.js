import axios from "axios";
import { useState, useEffect } from "react";
import "./css/AllStories.css";

function MyStories() {
  const [myStories, setMyStories] = useState([]);
  const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;

  function formatDate(dateString) {
    const date = new Date(dateString);
    const day = date.getDate();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const hours = date.getHours();
    const minutes = date.getMinutes().toString().padStart(2, "0");

    const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;

    return formattedDate;
  }

  useEffect(() => {
    axios
      .get(
        `http://${process.env.REACT_APP_BACKEND_URL}:8080/api/story/fromUser`,
        {
          withCredentials: true,
        }
      )
      .then((response) => {
        setMyStories(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [BACKEND_URL]);

  return (
    <div className="all-stories">
      <h1>My Stories</h1>
      {myStories.map((story) => (
        <div key={story.id} className="story">
          <h2 className="story-title">
            <a href={"/story/" + story.id}>{story.title}</a>
          </h2>
          <p className="story-details">
            <b>Likes:</b> {story.likes ? story.likes.length : 0}
          </p>
          <p className="story-details">
            <b>Labels:</b> {story.labels.join(", ")}
          </p>
          <p className="story-details">
            <b>Written by:</b>{" "}
            <a href={"/user/" + story.user.id}>{story.user.username}</a>
          </p>
          <p className="story-details">
            <b>Start Date:</b> {story.startTimeStamp}
          </p>
          <p className="story-details">
            <b>End Date:</b> {story.endTimeStamp}
          </p>
          <p className="story-details">
            <b>Published at:</b> {formatDate(story.createdAt)}
          </p>
          <p className="story-details">
            <b>Season:</b> {story.season}
          </p>
          <p className="story-details">
            <b>Locations:</b>
          </p>
          <ul className="locations-list">
            {story.locations.map((location) => (
              <li key={location.id}>{location.locationName}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}

export default MyStories;
