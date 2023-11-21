import React, { useState, useEffect } from "react";
import axios from "axios";
import { Circle, GoogleMap, LoadScript, Marker, Polygon, Polyline, StandaloneSearchBox } from "@react-google-maps/api";
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
  const [startTimeStamp, setStartTimeStamp] = useState(null);
  const [endTimeStamp, setEndTimeStamp] = useState(null);
  const [season, setSeason] = useState("");
  const [decade, setDecade] = useState("");
  const [searchBox, setSearchBox] = useState(null);
  const [currentShape, setCurrentShape] = useState(null);
  const [tempPoints, setTempPoints] = useState([]);
  const [circleRadius, setCircleRadius] = useState(5000);

  const [markers, setMarkers] = useState([]);
  const [circles, setCircles] = useState([]);
  const [polygons, setPolygons] = useState([]);
  const [polylines, setPolylines] = useState([]);


  const onSearchBoxLoad = (ref) => {
    setSearchBox(ref);
  };

  // Location related event handlers
  const onPlacesChanged = () => {
    const places = searchBox.getPlaces();
    const place = places[0];
    if (!place.geometry) return;

    const newMarker = {
      latitude: place.geometry.location.lat(),
      longitude: place.geometry.location.lng(),
      name: place.formatted_address,
    };

    setMarkers([...markers, newMarker]);
  };


  const handleRemoveShape = (index, type) => {
    if (type === 'marker') {
      setMarkers(markers.filter((_, i) => i !== index));
    }
    else if (type === 'polygon') {
      setPolygons(polygons.filter((_, i) => i !== index));
    } else if (type === 'polyline') {
      setPolylines(polylines.filter((_, i) => i !== index));
    } else if (type === 'circle') {
      setCircles(circles.filter((_, i) => i !== index));
    }
  };


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
    if (markers.length === 0 && circles.length === 0 && polygons.length === 0 && polylines.length === 0) {
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

    // Create story object to be sent to backend
    const story = {
      title,
      labels: labels.split(","),
      text,
      locations: [
        ...markers.map((point, markerIndex) => ({
          locationName: point.name,
          latitude: point.latitude,
          longitude: point.longitude,
          circleRadius: null,
          isCircle: null,
          isPolyline: null,
          isPolygon: null,
          isPoint: markerIndex, // Index for standalone points
        })),
        ...circles.map((circle, circleIndex) => ({
          locationName: circle.center.name,
          latitude: circle.center.lat,
          longitude: circle.center.lng,
          circleRadius: circle.radius,
          isCircle: circleIndex,
          isPolyline: null,
          isPolygon: null,
          isPoint: null,
        })),
        ...polygons.flatMap((polygon, polygonIndex) =>
          polygon.paths.map(point => ({
            locationName: point.name,
            latitude: point.lat,
            longitude: point.lng,
            circleRadius: null,
            isCircle: null,
            isPolyline: null,
            isPolygon: polygonIndex,
            isPoint: null,
          }))
        ),
        ...polylines.flatMap((polyline, polylineIndex) =>
          polyline.path.map(point => ({
            locationName: point.name,
            latitude: point.lat,
            longitude: point.lng,
            circleRadius: null,
            isCircle: null,
            isPolyline: polylineIndex,
            isPolygon: null,
            isPoint: null,
          }))
        )
      ],
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
    let locationName = "";

    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json?latlng=${clickedLat},${clickedLng}&key=${process.env.REACT_APP_GOOGLE_MAPS_API_KEY}`
      );
      locationName = response.data.results[0]?.formatted_address || "Unknown Location";
      console.log(response.data.results);
    } catch (error) {
      console.error("Error in reverse geocoding:", error);
      alert("Failed to fetch location name");
      locationName = "Unknown Location"
    }

    if (currentShape === 'marker') {

      const newMarker = {
        latitude: clickedLat,
        longitude: clickedLng,
        name: locationName,
        id: markers.length, // Unique identifier based on the current length of the array
      };
      setMarkers([...markers, newMarker]);

    } else if (currentShape === 'circle') {
      const newCircle = {
        center: { lat: clickedLat, lng: clickedLng, name: locationName },
        radius: circleRadius,
        name: locationName,
        id: circles.length // Unique identifier based on the current length of the array
      };
      setCircles([...circles, newCircle]);
    }

    else {
      // For polygons and polylines, add temporary points
      setTempPoints([...tempPoints, { lat: clickedLat, lng: clickedLng, name: locationName }]);
    }
  };

  const finishShape = () => {
    if (currentShape === 'polygon' && tempPoints.length > 2) {
      // Get location name of the last point

      const newPolygon = {
        id: polygons.length, // Unique identifier based on the current length of the array
        paths: tempPoints,
      };
      setPolygons([...polygons, newPolygon]);
    } else if (currentShape === 'polyline' && tempPoints.length > 1) {
      const newPolyline = {
        id: polylines.length, // Unique identifier based on the current length of the array
        path: tempPoints.map(p => ({ lat: p.lat, lng: p.lng, name: p.name })),
      };
      setPolylines([...polylines, newPolyline]);
    }
    setTempPoints([]); // Reset temporary points
  };


  // TimeResolution Handlers
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

  useEffect(() => {
    if (startTimeStamp) {
      const startYear = getYear(startTimeStamp);
      const startDecade = startYear - (startYear % 10);
      setDecade(`${startDecade}s`);
    } else {
      setDecade("");
    }
  }, [startTimeStamp]);

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
        <div className="map-controls d-flex flex-column align-items-left-b"
          style={{ width: 'auto', height: 'auto', marginLeft: '5px' }}> {/* Added margin here */}
          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={() => setCurrentShape('marker')}>
            <i class="bi bi-geo-alt-fill"></i> {/* Marker Icon */}
          </button>
          <div class="d-flex align-items-center mb-2">
            <button type="button" className="btn btn-primary " style={{ width: "50px" }} onClick={() => setCurrentShape('circle')}>
              <i class="bi bi-circle"></i> {/* Circle Icon */}
            </button>
            <input type="number" className="form-control"
              style={{ width: "150px", marginLeft: "5px" }}
              onChange={(e) => setCircleRadius(Number(e.target.value))}
              placeholder="Radius (m)"
            >
            </input>
          </div>

          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={() => setCurrentShape('polygon')}>
            <i className="bi bi-hexagon"></i> {/* Polygon Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={() => setCurrentShape('polyline')}>
            <i className="bi bi-arrow-right"></i> {/* Polyline Icon */}
          </button>
          <button type="button" className="btn btn-primary mb-2" style={{ width: "50px" }} onClick={finishShape} disabled={tempPoints.length < 2}>
            <i className="bi bi-check-lg"></i> {/* Finish Icon */}
          </button>
        </div>
      </div>

      <br />
      <br />
      <div className="add-story-locations">
        <label className="add-story-label">Locations:</label>
        <ul className="add-story-location-list">
          {/* Display marker locations */}
          {markers.map((marker, index) => (
            <li key={`marker-${index}`} className="add-story-location-item">
              Marker: {index + 1} - {marker.name}
              <button
                type="button"
                class="btn btn-danger m-2"
                onClick={() => { handleRemoveShape(index, 'marker') }}
              > Remove
              </button>
            </li>
          ))}
          {/* Display circles */}
          {circles.map((circle, index) => (
            <li key={`circle-${index}`} className="add-story-location-item">
              Circle {index + 1} - {circle.name} (Radius:{circle.radius}m)
              <button
                type="button"
                class="btn btn-danger m-1"
                onClick={() => handleRemoveShape(index, 'circle')}
              > Remove
              </button>
            </li>
          ))}
          {/* Display polygons */}
          {polygons.map((polygon, index) => (
            <li key={`polygon-${index}`} className="add-story-location-item">
              Polygon {index + 1} - {polygon.paths[0].name} - Nodes:{polygon.paths.length}
              <button
                type="button"
                class="btn btn-danger m-1"
                onClick={() => handleRemoveShape(index, 'polygon')}
              > Remove
              </button>
            </li>
          ))}

          {/* Display polylines */}
          {polylines.map((polyline, index) => (
            <li key={`polyline-${index}`} className="add-story-location-item">
              Polyline {index + 1} - {polyline.path[0].name} - Nodes:{polyline.path.length}
              <button
                type="button"
                class="btn btn-danger m-1"
                onClick={() => handleRemoveShape(index, 'polyline')}
              >
                Remove
              </button>
            </li>
          ))}
        </ul>
      </div>
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

