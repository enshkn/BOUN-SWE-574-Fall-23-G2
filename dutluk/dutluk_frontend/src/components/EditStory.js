import React, { useState, useEffect, useCallback } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";
import { useParams } from "react-router-dom";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import "quill-emoji/dist/quill-emoji.css";
import DatePicker from "react-datetime-picker";
import "react-datetime-picker/dist/DateTimePicker.css";
import { format, getYear } from "date-fns";
import { useNavigate } from "react-router-dom";
import { Space, message } from 'antd';
import "./css/EditStory.css";

const EditStoryForm = () => {
  const { id } = useParams();
  const [messageApi, contextHolder] = message.useMessage();

  const fetchStoryData = useCallback(async () => {
    try {
      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/${id}`,
        {
          withCredentials: true,
        }
      );
      const existingStory = response.data;

      setTitle(existingStory.title);
      setLabels(existingStory.labels.join(","));
      setText(existingStory.text);
      setLocations(existingStory.locations);
      setStartTimeStamp(new Date(existingStory.startTimeStamp));
      setEndTimeStamp(
        existingStory.endTimeStamp ? new Date(existingStory.endTimeStamp) : null
      );
      setSeason(existingStory.season);
      setDecade(existingStory.decade);
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while fetching the story data!"});
    }
  }, [id, messageApi]);

  useEffect(() => {
    fetchStoryData();
  }, [id, fetchStoryData]);

  const [title, setTitle] = useState("");
  const [labels, setLabels] = useState("");
  const [text, setText] = useState("");
  const [locations, setLocations] = useState([]);
  const [geocodedLocations, setGeocodedLocations] = useState([]);
  const [startTimeStamp, setStartTimeStamp] = useState(null);
  const [endTimeStamp, setEndTimeStamp] = useState(null);
  const [season, setSeason] = useState("");
  const [decade, setDecade] = useState("");

  useEffect(() => {
    if (startTimeStamp) {
      const startYear = getYear(startTimeStamp);
      const startDecade = startYear - (startYear % 10);
      setDecade(`${startDecade}s`);
    } else {
      setDecade("");
    }
  }, [startTimeStamp]);

  const navigate = useNavigate();

  const handleEditorChange = (value) => {
    setText(value);
  };

  const handleEditSubmit = async (event) => {
    event.preventDefault();
    const currentDateTime = new Date();
  
    if (startTimeStamp && startTimeStamp > currentDateTime) {
      return;
    }
  
    if (endTimeStamp && endTimeStamp > currentDateTime) {
      return;
    }
  
    let formattedStartTimeStamp = null;
    let formattedEndTimeStamp = null;
  
    if (decade) {
      formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
      formattedEndTimeStamp = format(endTimeStamp, "yyyy-MM-dd HH:mm");
    } else {
      formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
      formattedEndTimeStamp = endTimeStamp
        ? format(endTimeStamp, "yyyy-MM-dd HH:mm")
        : null;
    }
  
    const editedStory = {
      title,
      labels: labels.split(","),
      text,
      locations: locations.map((location) => ({
        locationName: location.name,
        latitude: location.latitude,
        longitude: location.longitude,
      })),
      startTimeStamp: formattedStartTimeStamp,
      endTimeStamp: formattedEndTimeStamp,
      season,
      decade,
    };
  
    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/edit/${id}`,
        editedStory,
        {
          withCredentials: true,
        }
      );
      console.log(response);
      navigate("/user/my-profile")
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while trying to edit the story!"});
    }
  };
  

  const mapContainerStyle = {
    width: "80%",
    height: "400px",
  };

  const center = {
    lat: 41.085064,
    lng: 29.044687,
  };

  const modules = {
    toolbar: [
      [{ header: [1, 2, false] }],
      ["bold", "italic", "underline", "strike", "blockquote"],
      [{ list: "ordered" }, { list: "bullet" }],
      ["link", "image"],
    ],
  };

  const formats = [
    "header",
    "bold",
    "italic",
    "underline",
    "strike",
    "blockquote",
    "list",
    "bullet",
    "indent",
    "link",
    "image",
  ];

  const handleMapClick = async (event) => {
    const clickedLat = event.latLng.lat();
    const clickedLng = event.latLng.lng();

    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json?latlng=${clickedLat},${clickedLng}&key=${process.env.REACT_APP_GOOGLE_MAPS_API_KEY}`
      );
      const locationName = response.data.results[0]?.formatted_address || "";
      console.log(response.data.results);
      const newLocation = {
        latitude: clickedLat,
        longitude: clickedLng,
        name: locationName,
      };
      setLocations([...locations, newLocation]);
      setGeocodedLocations([...geocodedLocations, locationName]);
    } catch (error) {
      console.log("Error:", error);
      messageApi.open({ type: "error", content: "Error occured while getting map coordinates!"});
    }
  };

  const handleStartDateChange = (date) => {
    setStartTimeStamp(date);
    const startYear = getYear(date);
    const startDecade = startYear - (startYear % 10);
    setDecade(`${startDecade}s`);
  };

  const handleDecadeChange = (decade) => {
    setDecade(decade);
  };

  const handleEndDateChange = (date) => {
    setEndTimeStamp(date);
  };

  return (
    <Space
    direction="vertical"
    style={{
      width: '100%',
    }}
    >
    {contextHolder}
    <form className="edit-story-form" onSubmit={handleEditSubmit}>
      <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}>
        <GoogleMap
          mapContainerStyle={mapContainerStyle}
          center={center}
          zoom={10}
          onClick={handleMapClick}
        >
          {locations.map((location, index) => (
            <Marker
              key={index}
              position={{
                lat: location.latitude,
                lng: location.longitude,
              }}
            />
          ))}
        </GoogleMap>
      </LoadScript>
      <br />
      <br />
      {geocodedLocations.length > 0 && (
        <div className="edit-story-locations">
          <label className="edit-story-label">Locations:</label>
          <ul className="edit-story-location-list">
            {geocodedLocations.map((location, index) => (
              <li key={index} className="edit-story-location-item">
                {location}
              </li>
            ))}
          </ul>
        </div>
      )}
      <br />
      <label className="edit-story-label">
        Title:
        <input
          type="text"
          className="edit-story-input"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
      </label>
      <br />
      <label className="edit-story-label">
        Labels:(comma separated)
        <input
          type="text"
          className="add-story-input"
          value={labels}
          onChange={(e) => setLabels(e.target.value)}
        />
      </label>
      <br />
      <label className="edit-story-label">
        Text:
        <ReactQuill
          value={text}
          onChange={handleEditorChange}
          modules={modules}
          formats={formats}
          className="edit-story-editor"
        />
      </label>
      <label className="edit-story-label">
        Start Date and Time:
        <DatePicker
          value={startTimeStamp}
          onChange={handleStartDateChange}
          className="edit-story-datepicker"
        />
      </label>
      <br />
      <label className="edit-story-label">
        End Date and Time:
        <DatePicker
          value={endTimeStamp}
          onChange={handleEndDateChange}
          className="edit-story-datepicker"
        />
      </label>
      <br />
      <label className="edit-story-label">
        Season:
        <select
          value={season}
          onChange={(e) => setSeason(e.target.value)}
          className="edit-story-select"
        >
          <option value="">Select Season</option>
          <option value="Spring">Spring</option>
          <option value="Summer">Summer</option>
          <option value="Fall">Fall</option>
          <option value="Winter">Winter</option>
        </select>
      </label>
      <br />
      <label className="edit-story-label">
        Decade:
        <select
          value={decade}
          onChange={handleDecadeChange}
          className="edit-story-select"
        >
          <option value="">Select Decade</option>
          <option value="1940s">1940s</option>
          <option value="1950s">1950s</option>
          <option value="1960s">1960s</option>
          <option value="1970s">1970s</option>
          <option value="1980s">1980s</option>
          <option value="1990s">1990s</option>
          <option value="2000s">2000s</option>
          <option value="2010s">2010s</option>
          <option value="2020s">2020s</option>
        </select>
      </label>
      <br />
      <button type="submit" className="edit-story-button">
        Edit Story
      </button>
    </form>
    </Space>
  );
};

export default EditStoryForm;
