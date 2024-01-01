import React, { useState, useEffect, useCallback } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";
import { Space, message } from 'antd';
import "./css/StorySearch.css";
import Timeline from "./Timeline";

const TimelineSearch = () => {
  const [searchResults, setSearchResults] = useState([]);
  const [radius, setRadius] = useState(null);
  const [selectedLocation, setSelectedLocation] = useState(null);
  const [searchDate, setSearchDate] = useState({ type: null, value: null });
  const [searchSeason, setSearchSeason] = useState(null);
  const [searchDecade, setSearchDecade] = useState(null);
  const [messageApi, contextHolder] = message.useMessage();

  const handleSearch = useCallback(async () => {
    try {
      let startDate = null;
      let endDate = null;

      switch (searchDate.type) {
        case "absolute-date":
          startDate = searchDate.value;
          endDate = searchDate.value;
          break;
        case "interval-date":
          startDate = searchDate.value.startDate;
          endDate = searchDate.value.endDate;
          break;
        case "absolute-year":
          startDate = `${searchDate.value}-01-01`;
          endDate = `${searchDate.value}-12-31`;
          break;
        case "interval-year":
          startDate = `${searchDate.value.startDate}-01-01`;
          endDate = `${searchDate.value.endDate}-12-31`;
          break;
        default:
          break;
      }

      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/search/timeline`,
        {
          params: {
            radius: radius,
            latitude: selectedLocation ? selectedLocation.lat : null,
            longitude: selectedLocation ? selectedLocation.lng : null,
            startTimeStamp: startDate,
            endTimeStamp: endDate,
            season: searchSeason,
            decade: searchDecade,
          },
          withCredentials: true,
        }
      );

      setSearchResults(response.data);
    } catch (error) {
      console.log(error);
      messageApi.open({ type: "error", content: "Error occured while searching stories!" });
    }
  }, [
    radius,
    selectedLocation,
    searchDate,
    searchSeason,
    searchDecade,
    messageApi,
  ]);

  const handleMapClick = (event) => {
    const clickedLat = event.latLng.lat();
    const clickedLng = event.latLng.lng();
    setSelectedLocation({ lat: clickedLat, lng: clickedLng });
  };

  const handleMarkerReClick = () => {
    setSelectedLocation(null);
  };

  useEffect(() => {
  }, []); 
  

  const handleDateTypeChange = (event) => {
    const type = event.target.value;
    setSearchDate({ type, value: null });
  };

  const handleSeasonChange = (event) => {
    const season = event.target.value;
    setSearchSeason(season);
  };

  const handleDecadeChange = (event) => {
    const decade = event.target.value;
    setSearchDecade(decade);
  };

  const handleSearchByLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userLocation = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };
          setSelectedLocation(userLocation);
        },
        (error) => {
          console.error("Error getting user location:", error);
          messageApi.open({
            type: "error",
            content: "Error getting user location. Please try again.",
          });
        }
      );
    } else {
      messageApi.open({
        type: "error",
        content: "Geolocation is not supported by your browser.",
      });
    }
  };

  return (
    <Space
      direction="vertical"
      style={{
        width: '100%',
      }}
    >
      {contextHolder}
      <center><h2>Timeline Search</h2></center>

      <div  className="story-search" style={{ display: 'flex' }} >
        <div className="search-form" style={{ flex: 1 }}>
          <div className="col-md-6">
            <label htmlFor="radius" className="form-label">Radius (in km):</label>
            <input
              id="radius"
              type="number"
              className="form-control"
              value={radius}
              onChange={(e) => setRadius(parseInt(e.target.value))}
            />
            
          </div>
          <button type="button" className="btn btn-primary" style={{backgroundColor: "#ff5500ca", color: "white",   border: "none", margin: "5px"}} onClick={handleSearchByLocation}>
            Use My Location
        </button>
          {/* Time Type Picker Element */}
          <div className="col-md-6">
            <label htmlFor="dateType" className="form-label">Date Type:</label>
            <select
              id="dateType"
              className="form-select"
              value={searchDate.type}
              onChange={handleDateTypeChange}
            >
              <option value="">Select a Date Type</option>
              <option value="absolute-date">Absolute Date</option>
              <option value="interval-date">Interval Date</option>
              <option value="absolute-year">Absolute Year</option>
              <option value="interval-year">Interval Year</option>
            </select>

          </div>

          {searchDate.type === "absolute-date" && (
            <div className="col-md-6">
              <label htmlFor="searchDate" className="form-label">
                Date:
              </label>
              <input
                type="date"
                className="form-control"
                id="searchDate"
                value={searchDate.value || ""}
                onChange={(e) =>
                  setSearchDate({ ...searchDate, value: e.target.value })
                }
              />

            </div>
          )}

          {searchDate.type === "interval-date" && (
            <div className="col-md-6">

              <div className="mb-3">
                <label htmlFor="startDate" className="form-label">
                  Start Date:
                </label>
                <input
                  type="date"
                  className="form-control"
                  id="startDate"
                  value={searchDate.value?.startDate || ""}
                  onChange={(e) =>
                    setSearchDate({
                      ...searchDate,
                      value: { ...searchDate.value, startDate: e.target.value },
                    })
                  }
                />

              </div>

              <div className="mb-3">
                <label htmlFor="endDate" className="form-label">
                  End Date:
                </label>
                <input
                  type="date"
                  className="form-control"
                  id="endDate"
                  value={searchDate.value?.endDate || ""}
                  onChange={(e) =>
                    setSearchDate({
                      ...searchDate,
                      value: { ...searchDate.value, endDate: e.target.value },
                    })
                  }
                />
              </div>

            </div>
          )}

          {searchDate.type === "absolute-year" && (
            <div className="col-md-6">
              <label htmlFor="yearInput" className="form-label">
                Year:
              </label>
              <input
                type="number"
                className="form-control"
                id="yearInput"
                value={searchDate.value || ""}
                onChange={(e) =>
                  setSearchDate({ ...searchDate, value: e.target.value })
                }
              />
            </div>
          )}
          {searchDate.type === "interval-year" && (
            <div className="col-md-6">
              <div className="mb-3">
                <label htmlFor="startYear" className="form-label">
                  Start Year:
                </label>
                <input
                  type="number"
                  className="form-control"
                  id="startYear"
                  value={searchDate.value?.startDate || ""}
                  onChange={(e) =>
                    setSearchDate({
                      ...searchDate,
                      value: { ...searchDate.value, startDate: e.target.value },
                    })
                  }
                />
              </div>
              <div className="mb-3">
                <label htmlFor="endYear" className="form-label">
                  End Year:
                </label>
                <input
                  type="number"
                  className="form-control"
                  id="endYear"
                  value={searchDate.value?.endDate || ""}
                  onChange={(e) =>
                    setSearchDate({
                      ...searchDate,
                      value: { ...searchDate.value, endDate: e.target.value },
                    })
                  }
                />

              </div>
            </div>
          )}

          {/* Season Picker Element */}
          <div className="col-md-6">
            <label htmlFor="season" className="form-label">Season:</label>
            <select
              id="season"
              className="form-select"
              value={searchSeason}
              onChange={handleSeasonChange}
            >
              <option value="">Select a Season</option>
              <option value="spring">Spring</option>
              <option value="summer">Summer</option>
              <option value="fall">Fall</option>
              <option value="winter">Winter</option>
            </select>
          </div>
          {/* Decade Picker Element */}
          <div className="col-md-6">
            <label htmlFor="decade" className="form-label">Decade:</label>
            <select
              id="decade"
              className="form-select"
              value={searchDecade}
              onChange={handleDecadeChange}
            >
              <option value="">Select a Decade</option>
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
          </div>
          <div className="col-md-6 mt-3">
            <button
              type="button"
              className="btn btn-primary"
              onClick={handleSearch}
            >
              Search
            </button>
          </div>
        </div>

        <div className="map-section" style={{ flex: 1, marginRight: 10 }}>
          <LoadScript
            googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}
          >
            <GoogleMap
              mapContainerStyle={{ width: "100%", height: "400px" }}
              center={{ lat: 41.085064, lng: 29.044687 }}
              zoom={10}
              onClick={handleMapClick}
            >
              {selectedLocation && (
                <Marker
                  position={{
                    lat: selectedLocation.lat,
                    lng: selectedLocation.lng,
                  }}
                  onClick={handleMarkerReClick}
                />
              )}
            </GoogleMap>
          </LoadScript>
          {searchResults.length > 0 && (
            <div>
              <h3>Search Results:</h3>
              <Timeline
                items={searchResults.map(result => ({
                  id: result.id,
                  title: result.title,
                  image: result.picture || "https://images.unsplash.com/photo-1682687220063-4742bd7fd538?q=80&w=1375&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 
                  description: result.text,
                  date: result.timeExpression,
                }))}
                visibleCount={3} // Set the number of visible stories
              />
            </div>
          )}
        </div>
      </div>
    </Space>
  );
};

export default TimelineSearch;
