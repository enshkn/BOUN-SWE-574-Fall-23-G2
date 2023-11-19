import axios from "axios";
import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import "./css/AllStories.css";

const LabelSearch = () => {
  const { label } = useParams();
  const [labeledStories, setLabeledStories] = useState([]);

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
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/search/label?label=${label}`, {
        withCredentials: true,
      })
      .then((response) => {
        setLabeledStories(response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, [label]);

  return (
    <div className="all-stories">
      <h1>Stories with Label: "{label}"</h1>
      {labeledStories.length > 0 ? (
        labeledStories.map((story) => (
          <div key={story.id} className="story">
          <h2 className="story-title">
            <a href={"/story/" + story.id}>{story.title}</a>
          </h2>
          <p className="story-details">
            <b>Likes:</b> {story.likes ? story.likes.length : 0}
          </p>
          <p className="story-details">
            <b>Labels:</b>{" "}
            {story.labels.map((label, index) => (
              <span key={index}>
                <a href={"/story/search/label/"+label}>{label}</a>
                {index < story.labels.length - 1 && ", "}
              </span>
            ))}
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
        ))
      ) : (
        <p>No stories found with the label "{label}"</p>
      )}
    </div>
  );
};

export default LabelSearch;
