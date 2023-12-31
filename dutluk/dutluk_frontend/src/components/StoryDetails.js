import axios from "axios";
import { useEffect, useState, useCallback } from "react";
import { Space, message } from 'antd';
import parse from "html-react-parser";
import { useParams } from "react-router-dom";
import { GoogleMap, LoadScript, Marker, Circle, Polygon, Polyline } from "@react-google-maps/api";
import "react-quill/dist/quill.snow.css";
import "./css/AllStories.css";
import "./css/StoryDetails.css";
import CommentList from "./CommentList";

function StoryDetails() {
  const { id } = useParams();
  const [story, setStory] = useState();
  const [commentText, setCommentText] = useState("");
  const [messageApi, contextHolder] = message.useMessage();
  const [isLiked, setIsLiked] = useState(false);

  const [markers, setMarkers] = useState([]);
  const [circles, setCircles] = useState([]);
  const [polygons, setPolygons] = useState([]);
  const [polylines, setPolylines] = useState([]);

  const convertLocations = (story) => {

    const tempMarkers = story.locations.filter(location => location.isPoint !== null);
    const tempCircles = story.locations.filter(location => location.isCircle !== null);
    const tempPolygons = story.locations.filter(location => location.isPolygon !== null);
    const tempPolylines = story.locations.filter(location => location.isPolyline !== null);

    // Markers
    tempMarkers.forEach((location) => {
      setMarkers(prevMarkers => [
        ...prevMarkers,
        {
          latitude: location.latitude,
          longitude: location.longitude,
          name: location.locationName,
          id: location.id
        }
      ]);
    });
    // Circles
    tempCircles.forEach((location) => {
      setCircles(prevCircles => [
        ...prevCircles,
        {
          center: { lat: location.latitude, lng: location.longitude, name: location.locationName },
          radius: location.circleRadius,
          id: location.id,
          name: location.locationName,
        }
      ]);
    });
    // Polylines
    // Group polylines by polyline id
    const groupedPolylines = tempPolylines.reduce((acc, location) => {
      if (location.isPolyline !== null) {
        if (!acc[location.isPolyline]) {
          acc[location.isPolyline] = [];
        }
        acc[location.isPolyline].push({
          lat: location.latitude,
          lng: location.longitude
        });
      }
      return acc;
    }, {});

    // Extract polylines by polyline id
    Object.keys(groupedPolylines).forEach(key => {
      setPolylines(prevPolylines => [
        ...prevPolylines,
        {
          id: key,
          path: groupedPolylines[key]
        }
      ]);
    });

    // Polygons
    // Group polygons by polygons id
    const groupedPolygons = tempPolygons.reduce((acc, location) => {
      if (location.isPolygon !== null) {
        if (!acc[location.isPolygon]) {
          acc[location.isPolygon] = [];
        }
        acc[location.isPolygon].push({
          lat: location.latitude,
          lng: location.longitude
        });
      }
      return acc;
    }, {});

    // Extract polygons by polygons id
    Object.keys(groupedPolygons).forEach(key => {
      setPolygons(prevPolygons => [
        ...prevPolygons,
        {
          id: key,
          path: groupedPolygons[key]
        }
      ]);
    });
  };

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/story/${id}`, {
        withCredentials: true,
      })
      .then((response) => {
        setStory(response.data);
        convertLocations(response.data);
      })
      .catch((error) => {
        console.log(error);
        messageApi.open({ type: "error", content: "Error occured while loading the story!" });
      });
  }, [id, messageApi]);

  const handleCommentSubmit = async (event) => {
    event.preventDefault();

    const comment = {
      storyId: story.id,
      commentText: commentText,
    };

    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/comment/add`,
        comment,
        {
          withCredentials: true,
        }
      );
      console.log(comment);
      const updatedStory = { ...story };
      updatedStory.comments.push(response.data);
      setStory(updatedStory);
      setCommentText("");
      messageApi.open({ type: "success", content: "Your comment is posted!" });
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while posting your comment!" });
    }
  };

  const fetchLikeStatus = useCallback(async () => {
    try {
      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/isLikedByUser/${id}`,
        {
          withCredentials: true,
        }
      );
      setIsLiked(response.data);
    } catch (error) {
      console.error('Like status API error:', error.message);
      messageApi.open({ type: "error", content: "Error occurred while fetching liked story data!" });
    }
  }, [id, messageApi]);

  useEffect(() => {
    fetchLikeStatus();
  }, [fetchLikeStatus]);

  const handleLikeStory = async () => {
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/like/`,
        { likedEntityId: story.id },
        {
          withCredentials: true,
        }
      );
      setStory(response.data);
      setIsLiked(!isLiked);
      if (isLiked === true) {
        messageApi.open({ type: "success", content: "You unliked this story" });
      } else if (isLiked === false) {
        messageApi.open({ type: "success", content: "You liked this story" });
      }
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while liking this story!" });
    }
  };

  if (!story) {
    messageApi.open({ type: "error", content: "Story Not Found!" });
    return <div>Story Not Found!</div>;
  }

  return (
    <Space
      direction="vertical"
      style={{
        width: '100%',
      }}
    >
      {contextHolder}
      <div className="story-container">
        <div className="story-header">
          <h1 className="story-title">{story.title}</h1>
          <div className="user-info">
            <span className="story-date"> Posted: {story.createdAt}</span>
            <a href={`/user/${story.user.id}`} className="username">@{story.user.username}</a>
          </div>
          <div className="interaction-info">
            <span style={{ marginRight: '8px' }}>
              ❤️ {story.likes ? story.likes.length : 0}
            </span>
            <span>
              💬 {story.comments.length}
            </span>
          </div>
        </div>
        <div className="story-map-container" style={{ display: 'flex' }} >
          <div className="story-content" style={{ flex: 5 }}>
            <div className="story-labels-and-like">
              <div className="label">
                <div className="tags">
                  {story.labels.map((tag, idx) => (
                    <span key={idx} className="tag">
                      <a href={"/story/search/label/" + tag}>{tag}</a>
                    </span>
                  ))}
                </div>
              </div>
              <button className="like-button" onClick={handleLikeStory} style={{ backgroundColor: "#ff5500ca", color: "white", border: "none" }} type="submit">
                {isLiked ? 'Unlike' : 'Like!'}
              </button>
            </div>

            {story.verbalExpression != null ? (
              <   span className="story-date">{story.verbalExpression}</span>
            ) : (
              <>
                {story.startTimeStamp && <span >Start: {story.startTimeStamp}</span>}
                {story.endTimeStamp && <span>End: {story.endTimeStamp}</span>}
                {story.season && <span>Season: {story.season}</span>}
                {story.endSeason && <span>Season: {story.endSeason}</span>}
                {story.decade && <span>Decade: {story.decade}</span>}
                {story.endDecade && <span>End Decade: {story.endDecade}</span>}
              </>
            )}

            <div className="story-text">
              {parse(story.text)}
            </div>
          </div>
          <div className="map-container" style={{ flex: 5 }}>
            <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY} >
              <GoogleMap
                mapContainerStyle={{ width: '100%', height: '100%', minHeight: '300px' }} // Adjust the height as needed
                center={{
                  lat: story.locations[0].latitude,
                  lng: story.locations[0].longitude,
                }}
                zoom={10}
              >
                {markers.map((marker, index) => (
                  <Marker
                    key={index}
                    position={{
                      lat: marker.latitude,
                      lng: marker.longitude,
                    }}
                  />
                ))}
                {circles.map((circle, index) => (
                  <Circle
                    key={index}
                    center={circle.center}
                    radius={circle.radius}
                  />
                ))}
                {polygons.map((polygon, index) => (
                  <Polygon
                    key={index}
                    paths={polygon.path}
                  />
                ))}
                {polylines.map((polyline, index) => (
                  <Polyline
                    key={index}
                    path={polyline.path}
                  />
                ))}
              </GoogleMap>
            </LoadScript>
            <div className="locations-list-container">
              <label><b>Selected Locations:</b></label>
              <div className="location-container">
                <ul className="locations-list">
                  {story.locations.map((location) => (
                    <li key={location.id}>{location.locationName}</li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="story-comments">
        <p>
          <b>Comments:</b>
        </p>
        {story.comments.map((comment) => (
          <CommentList comment={comment} story={story} key={comment} />
        ))}
        <form onSubmit={handleCommentSubmit} style={{ width: "80%" }}>
          <div>
            <textarea
              className="comment-textarea"
              label="Add Comment"
              value={commentText}
              placeholder="Add Comment"
              onChange={(e) => setCommentText(e.target.value)}
            ></textarea>
          </div>
          <button type="submit" className="btn btn-primary" style={{ width: "100px", backgroundColor: "#ff5500ca", color: "white", border: "none" }}>Submit</button>
        </form>
      </div>

    </Space>
  );
}

export default StoryDetails;
