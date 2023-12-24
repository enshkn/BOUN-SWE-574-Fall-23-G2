import React, { useState, useEffect, useCallback } from "react";
import axios from "axios";
import { GoogleMap, LoadScript, Marker } from "@react-google-maps/api";
import { Space, message } from 'antd';
import "./css/StorySearch.css";
import { Timeline } from 'antd';

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
        `${process.env.REACT_APP_BACKEND_URL}/api/story/search`,
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
      messageApi.open({ type: "error", content: "Error occured while searching stories!"});
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
    handleSearch();
  }, [handleSearch, searchDate, searchSeason, searchDecade]);

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
    <div className="story-search">
      <h2>Timeline Search</h2>
      <div className="search-form">
        <label>
          Radius (in km):
          <input
            type="number"
            value={radius}
            onChange={(e) => setRadius(parseInt(e.target.value))}
          />
        </label>
        <button type="button" onClick={handleSearchByLocation}>
            Use My Location
        </button>
        <label>
          Date Type:
          <select value={searchDate.type} onChange={handleDateTypeChange}>
            <option value="">Select a Date Type</option>
            <option value="absolute-date">Absolute Date</option>
            <option value="interval-date">Interval Date</option>
            <option value="absolute-year">Absolute Year</option>
            <option value="interval-year">Interval Year</option>
          </select>
        </label>
        {searchDate.type === "absolute-date" && (
          <label>
            Date:
            <input
              type="date"
              value={searchDate.value || ""}
              onChange={(e) =>
                setSearchDate({ ...searchDate, value: e.target.value })
              }
            />
          </label>
        )}
        {searchDate.type === "interval-date" && (
          <>
            <label>
              Start Date:
              <input
                type="date"
                value={searchDate.value?.startDate || ""}
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, startDate: e.target.value },
                  })
                }
              />
            </label>
            <label>
              End Date:
              <input
                type="date"
                value={searchDate.value?.endDate || ""}
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, endDate: e.target.value },
                  })
                }
              />
            </label>
          </>
        )}
        {searchDate.type === "absolute-year" && (
          <label>
            Year:
            <input
              type="number"
              value={searchDate.value || ""}
              onChange={(e) =>
                setSearchDate({ ...searchDate, value: e.target.value })
              }
            />
          </label>
        )}
        {searchDate.type === "interval-year" && (
          <>
            <label>
              Start Year:
              <input
                type="number"
                value={searchDate.value?.startDate || ""}
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, startDate: e.target.value },
                  })
                }
              />
            </label>
            <label>
              End Year:
              <input
                type="number"
                value={searchDate.value?.endDate || ""}
                onChange={(e) =>
                  setSearchDate({
                    ...searchDate,
                    value: { ...searchDate.value, endDate: e.target.value },
                  })
                }
              />
            </label>
          </>
        )}
        <label>
          Season:
          <select value={searchSeason} onChange={handleSeasonChange}>
            <option value="">Select a Season</option>
            <option value="spring">Spring</option>
            <option value="summer">Summer</option>
            <option value="fall">Fall</option>
            <option value="winter">Winter</option>
          </select>
        </label>
        <label>
          Decade:
          <select value={searchDecade} onChange={handleDecadeChange}>
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
        </label>
        <button type="button" onClick={handleSearch}>
          Search
        </button>
      </div>
      <div className="search-results">
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
            <ul>
              {searchResults.map((result) => (
                <li key={result.id}>
                  <h2>
                  <Timeline
                  mode={"left"}
                  items={[
                  {
                    label: result.startTimeStamp,
                    children: <a href={`/story/${result.id}`}>{result.title}</a>,
                  },
                  ]}
                  />
                  </h2>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </div>
    </Space>
  );
};

export default TimelineSearch;
