import React, { useState, useCallback } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";
import { Space, message } from 'antd';
import "./css/StorySearch.css";
import 'bootstrap/dist/css/bootstrap.min.css';
import StoryList from "./StoryList";

// Explore was previous search feature, sisnce it applies all filters individualy
// and add them to same list, wording is changed from "search" to "explore". Component name
// and internal elements left same. 

const StorySearch = () => {
  const [searchQuery, setSearchQuery] = useState(null);
  const [searchResults, setSearchResults] = useState([]);
  const [radius, setRadius] = useState(null);
  const [selectedLocation, setSelectedLocation] = useState(null);
  const [searchDate, setSearchDate] = useState({ type: null, value: null });
  const [searchSeason, setSearchSeason] = useState(null);
  const [searchDecade, setSearchDecade] = useState(null);

  const [messageApi, contextHolder] = message.useMessage();

  const handleSearch = useCallback(async () => {
    if (searchQuery && searchQuery.length < 4) {
      return;
    }
    const isValidMonthYear = (input) => {
      const regex = /^(0[1-9]|1[0-2])-\d{4}$/;
      return regex.test(input);
    };
    let isValid = true;
    let errorMessage = '';

    // Validate Absolute Month-Year
    if (searchDate.type === "absolute-month" && !isValidMonthYear(searchDate.value.startDate)) {
      isValid = false;
      errorMessage = 'Invalid format for Month-Year. Expected MM-YYYY.';
    };
    if (searchDate.type === "interval-month" && (!isValidMonthYear(searchDate.value.startDate) || !isValidMonthYear(searchDate.value.endDate))) {
      isValid = false;
      errorMessage = 'Invalid format for Month-Year. Expected MM-YYYY.';
    };

    if (!isValid) {
      // Display error message or handle the error
      messageApi.open({ type: "error", content: errorMessage });
      return;
    }

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
        case "absolute-month":
          const [month, year] = searchDate.value.startDate.split("-");
          startDate = `${year}-${month}`;
          break;
        case "interval-month":
          const [startMonth, startYear] = searchDate.value.startDate.split("-");
          const [endMonth, endYear] = searchDate.value.endDate.split("-");
          startDate = `${startYear}-${startMonth}`;
          endDate = `${endYear}-${endMonth}`;
          break;
        default:
          break;
      }

      const response = await axios.get(
        `${process.env.REACT_APP_BACKEND_URL}/api/story/search`,
        {
          params: {
            query: searchQuery,
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
    messageApi,
    searchQuery,
    radius,
    selectedLocation,
    searchDate,
    searchSeason,
    searchDecade,
  ]);

  const handleMapClick = (event) => {
    const clickedLat = event.latLng.lat();
    const clickedLng = event.latLng.lng();
    setSelectedLocation({ lat: clickedLat, lng: clickedLng });
  };

  const handleMarkerReClick = () => {
    setSelectedLocation(null);
  };

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

  return (
    <Space
      direction="vertical"
      style={{
        width: '100%',
      }}
    >
      {contextHolder}
      <center><h1>Story Explore</h1></center>

      <div className="story-search" style={{ display: 'flex' }} >
        {/* Story Search Element */}
        <div className="search-form" style={{ flex: 3 }}>
          <form className="row g-3">
            <div className="col-md-15">
              <label htmlFor="searchQuery" className="form-label">Explore Query:</label>
              <input
                id="searchQuery"
                type="text"
                className="form-control"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    e.preventDefault();
                    handleSearch();
                  }
                }}
              />

            </div>
          </form>
          {/* Radius Element */}
          <div className="col-md-15">
            <label htmlFor="radius" className="form-label">Radius (in km):</label>
            <input
              id="radius"
              type="number"
              className="form-control"
              value={radius}
              onChange={(e) => setRadius(parseInt(e.target.value))}
            />
          </div>
          {/* Time Type Picker Element */}
          <div className="col-md-15">
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
              <option value="absolute-month">Absolute Month</option>
              <option value="interval-month">Interval Month</option>
            </select>
          </div>

          {searchDate.type === "absolute-date" && (
            <div className="col-md-15">
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
            <div className="col-md-15">

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
            <div className="col-md-15">
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
            <div className="col-md-15">
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
          {searchDate.type === "absolute-month" && (
            <div className="col-md-15">
              <label htmlFor="monthYear" className="form-label">Month-Year:</label>
              <input
                type="text"
                className="form-control"
                id="monthYear"
                placeholder="MM-YYYY"
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, startDate: e.target.value },
                  })
                }
              />
            </div>
          )}
          {searchDate.type === "interval-month" && (
            <div className="col-md-15">
              <label htmlFor="startMonthYear" className="form-label">Start Month-Year:</label>
              <input
                type="text"
                className="form-control"
                id="startMonthYear"
                placeholder="MM-YYYY"
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, startDate: e.target.value },
                  })
                }
              />
              <label htmlFor="endMonthYear" className="form-label">End Month-Year:</label>
              <input
                type="text"
                className="form-control"
                id="endMonthYear"
                placeholder="MM-YYYY"
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, endDate: e.target.value },
                  })
                }
              />
            </div>
          )}

          {/* Season Picker Element */}
          <div className="col-md-15">
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
          <div className="col-md-15">
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
          {/* Button  Element */}
          <div className="col-md-15 mt-3">
            <button
              type="button"
              className="btn btn-primary"
              style={{ backgroundColor: "#ff5500ca", color: "white", border: "none" }}
              onClick={handleSearch}
            >
              Explore
            </button>
          </div>

        </div>
        <div className="map-section" style={{ flex: 7, marginRight:"10px" }}>
          <LoadScript
            googleMapsApiKey={process.env.REACT_APP_GOOGLE_MAPS_API_KEY}
          >
            <GoogleMap
              mapContainerStyle={{ width: "100%", height: "400px", margin: "0 auto" }}
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
          <div style={{ marginBottom: "20px" }} />

        </div>
      </div>

      <div className="search-results">
        {searchResults.length > 0 && (
          <div className="all-stories">
            <center><h1>Exploring Results</h1></center>
            {searchResults.map((story) => (
              <StoryList story={story} key={story.id} />
            ))}
          </div>
        )}
      </div>
    </Space>
  );
};

export default StorySearch;
