import React, { useState, useEffect } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker, Polygon, Polyline, StandaloneSearchBox } from "@react-google-maps/api";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import "quill-emoji/dist/quill-emoji.css";
import DatePicker from "react-datetime-picker";
import "react-datetime-picker/dist/DateTimePicker.css";
import { format, getYear } from "date-fns";
import { useNavigate } from "react-router-dom"; // Import useHistory
import "./css/AddStory.css";

const AddStoryForm = () => {
  const [title, setTitle] = useState("");
  const [labels, setLabels] = useState("");
  const [text, setText] = useState("");
  const [locations, setLocations] = useState([]);
  const [geocodedLocations, setGeocodedLocations] = useState([]);
  const [startTimeStamp, setStartTimeStamp] = useState(null);
  const [endTimeStamp, setEndTimeStamp] = useState(null);
  const [season, setSeason] = useState("");
  const [decade, setDecade] = useState("");
  const [searchBox, setSearchBox] = useState(null);
  const [polygons, setPolygons] = useState([]); // For regions
  const [polylines, setPolylines] = useState([]); // For polylines
  const [currentShape, setCurrentShape] = useState(null);
  const [markers, setMarkers] = useState([]);
  const [tempPoints, setTempPoints] = useState([]);

  const onSearchBoxLoad = (ref) => {
    setSearchBox(ref);
  };


  const handleAddPolygon = (polygon) => {
    setPolygons([...polygons, polygon]);
  };

  const handleAddPolyline = (polyline) => {
    setPolylines([...polylines, polyline]);
  };

  const onPlacesChanged = () => {
    const places = searchBox.getPlaces();
    const place = places[0];
    if (!place.geometry) return;

    const newLocation = {
      latitude: place.geometry.location.lat(),
      longitude: place.geometry.location.lng(),
      name: place.formatted_address,
    };

    setLocations([...locations, newLocation]);
    setGeocodedLocations([...geocodedLocations, place.formatted_address]);
  };


  useEffect(() => {
    if (startTimeStamp) {
      const startYear = getYear(startTimeStamp);
      const startDecade = startYear - (startYear % 10);
      setDecade(`${startDecade}s`);
    } else {
      setDecade("");
    }
  }, [startTimeStamp]);

  const handleEditorChange = (value) => {
    setText(value);
  };

  const navigate = useNavigate(); // Create history object

  const handleSubmit = async (event) => {
    event.preventDefault();
    // Text validation
    if (!text || text.trim() === '' || text === '<p><br></p>') { // Check for empty or only whitespace
      alert("Story body cannot be empty.");
      return; // Prevent form submission if story body is empty
    }
    if (!startTimeStamp && !decade && !season) {
      alert("Please select at least one: Start Date, Decade, or Season");
      return; // Prevent form submission if no date is picked
    }
    // Location validation
    if (locations.length === 0) {
      alert("Please pick at least one location.");
      return; // Prevent form submission if no location is set
    }
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
      formattedEndTimeStamp = endTimeStamp
        ? format(endTimeStamp, "yyyy-MM-dd HH:mm")
        : null;
    } else {
      formattedStartTimeStamp = format(startTimeStamp, "yyyy-MM-dd HH:mm");
      formattedEndTimeStamp = null;
    }

    const story = {
      title,
      labels: labels.split(","),
      text,
      locations: locations.map((location) => ({
        locationName: location.name,
        latitude: location.latitude,
        longitude: location.longitude,
      })),
      polygons: polygons.map((polygon) => ({
      })),
      polylines: polylines.map((polyline) => ({
      })),
      startTimeStamp: formattedStartTimeStamp,
      endTimeStamp: formattedEndTimeStamp,
      season,
      decade,
    };

    try {
      const response = await axios.post(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/add`,
        story,
        {
          withCredentials: true,
        }
      );
      console.log(response);
      navigate('/');
    } catch (error) {
      console.log(error);
    }
  };

  const mapContainerStyle = {
    width: "100%",
    height: "100%",
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

    if (currentShape === 'marker') {
      try {
        const response = await axios.get(
          `https://maps.googleapis.com/maps/api/geocode/json?latlng=${clickedLat},${clickedLng}&key=${process.env.REACT_APP_GOOGLE_MAPS_API_KEY}`
        );
        const locationName = response.data.results[0]?.formatted_address || "Unknown Location";
        console.log(response.data.results);

        const newMarker = {
          latitude: clickedLat,
          longitude: clickedLng,
          name: locationName,
        };

        setLocations([...locations, newMarker]);
        setGeocodedLocations([...geocodedLocations, locationName]);
      } catch (error) {
        console.error("Error in reverse geocoding:", error);
        alert("Failed to fetch location name. Marker added with default name.");
        setLocations([...locations, { latitude: clickedLat, longitude: clickedLng, name: "Unknown Location" }]);
        setGeocodedLocations([...geocodedLocations, "Unknown Location"]);
      }
    } else {
      // For polygons and polylines, add temporary points
      setTempPoints([...tempPoints, { lat: clickedLat, lng: clickedLng }]);
    }
  };

  const finishShape = () => {
    if (currentShape === 'polygon' && tempPoints.length > 2) {
      setPolygons([...polygons, { paths: tempPoints }]);
    } else if (currentShape === 'polyline' && tempPoints.length > 1) {
      setPolylines([...polylines, { path: tempPoints }]);
    }
    setTempPoints([]); // Reset temporary points
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

  const handleRemoveLocation = (index) => {
    const updatedLocations = [...locations];
    const updatedGeocodedLocations = [...geocodedLocations];

    updatedLocations.splice(index, 1); // Remove the location at the specified index
    updatedGeocodedLocations.splice(index, 1); // Remove the corresponding geocoded location

    setLocations(updatedLocations);
    setGeocodedLocations(updatedGeocodedLocations);
  };

  return (
    <form className="add-story-form" onSubmit={handleSubmit}>
      <div className="d-flex">
        <div style={{ flexGrow: 3, minWidth: 800, minHeight: 600 }}> {/* Allow map container to grow and take available space */}
          <LoadScript googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}
            libraries={["places"]}>
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
              {polygons.map((polygon, index) => (
                <Polygon
                  key={index}
                  paths={polygon.paths}
                />
              ))}
              {polylines.map((polyline, index) => (
                <Polyline
                  key={index}
                  path={polyline.path}
                />
              ))}
              {/* Render temporary polygon or polyline */}
              {tempPoints.length > 0 && (
                currentShape === 'polygon' ? (
                  <Polygon
                    paths={[...tempPoints, tempPoints[0]]} // Close the polygon for visualization
                    options={{
                      fillColor: "lightblue",
                      fillOpacity: 0.5,
                      strokeColor: "blue",
                      strokeOpacity: 1,
                      strokeWeight: 2,
                    }}
                  />
                ) : currentShape === 'polyline' ? (
                  <Polyline
                    path={tempPoints}
                    options={{
                      fillColor: "lightblue",
                      fillOpacity: 0.5,
                      strokeColor: "blue",
                      strokeOpacity: 1,
                      strokeWeight: 2,
                    }}
                  />
                ) : null
              )}
            </GoogleMap>
            <StandaloneSearchBox onLoad={onSearchBoxLoad} onPlacesChanged={onPlacesChanged}>
              <input type="text" placeholder="Search" style={{ width: "100%", height: "40px" }} />
            </StandaloneSearchBox>
          </LoadScript>
        </div>
        <div className="map-controls d-flex flex-column align-items-left-b "
          style={{ minWidth: '50px', height: 'auto', marginLeft: '5px' }}> {/* Added margin here */}
          <button type="button" className="btn btn-primary mb-2" onClick={() => setCurrentShape('marker')}>
          <i class="bi bi-geo-alt-fill"></i> {/* Marker Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" onClick={() => setCurrentShape('polygon')}>
            <i className="bi bi-hexagon"></i> {/* Polygon Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" onClick={() => setCurrentShape('polyline')}>
            <i className="bi bi-arrow-right"></i> {/* Polyline Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" onClick={finishShape} disabled={tempPoints.length < 2}>
            <i className="bi bi-check-lg"></i> {/* Finish Icon */}
          </button>
        </div>
      </div>

      <br />
      <br />
      {geocodedLocations.length > 0 && (
        <div className="add-story-locations">
          <label className="add-story-label">Locations:</label>
          <ul className="add-story-location-list">
            {geocodedLocations.map((location, index) => (
              <li key={index} className="add-story-location-item">
                {location}
                <button
                  type="button"
                  className="remove-location-button"
                  onClick={() => handleRemoveLocation(index)}
                >
                  Remove
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
      <br />
      <label className="add-story-label">
        Title:
        <input
          type="text"
          className="add-story-input"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required={true}
        />
      </label>
      <br />
      <label className="add-story-label">
        Labels:(comma separated)
        <input
          type="text"
          className="add-story-input"
          value={labels}
          onChange={(e) => setLabels(e.target.value)}
          required={true}
        />
      </label>
      <br />
      <label className="add-story-label">
        Text:
        <ReactQuill
          value={text}
          onChange={handleEditorChange}
          modules={modules}
          formats={formats}
          className="add-story-editor"
        />
      </label>
      <label className="add-story-label">
        Start Date and Time:
        <DatePicker
          value={startTimeStamp}
          onChange={handleStartDateChange}
          className="add-story-datepicker"
        />
      </label>
      <br />
      <label className="add-story-label">
        End Date and Time:
        <DatePicker
          value={endTimeStamp}
          onChange={handleEndDateChange}
          className="add-story-datepicker"
        />
      </label>
      <br />
      <label className="add-story-label">
        Season:
        <select
          value={season}
          onChange={(e) => setSeason(e.target.value)}
          className="add-story-select"
        >
          <option value="">Select Season</option>
          <option value="Spring">Spring</option>
          <option value="Summer">Summer</option>
          <option value="Fall">Fall</option>
          <option value="Winter">Winter</option>
        </select>
      </label>
      <br />
      <label className="add-story-label">
        Decade:
        <select
          value={decade}
          onChange={handleDecadeChange}
          className="add-story-select"
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
      <button type="submit" className="add-story-button">
        Add Story
      </button>
    </form>
  );
};

export default AddStoryForm;
