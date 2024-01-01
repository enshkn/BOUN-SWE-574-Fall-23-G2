import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route} from "react-router-dom";
import "./App.css";
import DutlukLogo from "./dutluk_logo.png";
import User from "./components/User";
import Profile from "./components/Profile";
import Login from "./components/Login";
import Register from "./components/Register";
import AddStoryForm from "./components/AddStory";
import EditStoryForm from "./components/EditStory";
import StashedStories from "./components/SavedStories"; // Save feauture name was changed to stash in order to avoid confusion on the user side.
import LikedStories from "./components/LikedStories";
import StoryDetails from "./components/StoryDetails";
import Recommended from "./components/Recommended";
import AllStories from "./components/AllStories";
import FollowedUserStories from "./components/FollowedUserStories";
import StorySearch from "./components/StorySearch";
import TimelineSearch from "./components/TimelineSearch";
import LabelSearch from "./components/LabelSearch"; // Add import for LabelSearch
import axios from "axios";
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';
import { QRCode, FloatButton } from 'antd';
import { FileTextOutlined } from '@ant-design/icons';


function App() {
  const [loggedIn, setLoggedIn] = useState(false);
  const [size] = useState(600);

  useEffect(() => {
    if (sessionStorage.getItem('currentUserId')!==null) {
      setLoggedIn(true);
    }
    else {
      axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/user/profile`, {
        withCredentials: true,
      })
      .then((response) => {
        setLoggedIn(true);
      })
      .catch((error) => {
        setLoggedIn(false);
      });    }

  }, []);

  const handleLogout = () => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/user/logout`, null, {
        withCredentials: true,
      })
      .then((response) => {
        document.cookie =
          "Bearer=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/api;";
        setLoggedIn(false);
        sessionStorage.removeItem('currentUserId');
      })
      .catch((error) => {
        console.log(error);
      });
  };

  const isAddStoryPage = window.location.pathname === "/story/add-story";

  return (
    <Router>
      {!isAddStoryPage && loggedIn && (
        <FloatButton
          icon={<FileTextOutlined />}
          description="ADD STORY"
          shape="square"
          style={{
            position: "fixed",
            right: 94,
          }}
          href={"/story/add-story"}
        />
      )}
      <Navbar
        style={{ backgroundColor: "#ff5500ca", color: "white" }}
        expand="lg"
        sticky="top"
        className="nav"
      >
        <Container>
          <Navbar.Brand href="/">
            <img src={DutlukLogo} alt="Logo" className="logo" />
          </Navbar.Brand>
          {loggedIn ? (
            <>
              <NavDropdown
                title="Story"
                id="basic-nav-dropdown"
                className="justify-content-end"
              >
                <NavDropdown.Item
                  href="/story/followings" 
                  className="justify-content-end"
                >
                  Story Feed
                </NavDropdown.Item>
                <NavDropdown.Item
                  href="/story/recommended" 
                  className="justify-content-end"
                >
                  Recommended Stories
                </NavDropdown.Item>
                <NavDropdown.Item
                  href="/story/all-stories" 
                  className="justify-content-end"
                >
                  All Stories
                </NavDropdown.Item>
                <NavDropdown.Item
                  href="/story/stashed-stories"
                  className="justify-content-end"
                >
                  Stashed Stories
                </NavDropdown.Item>
                <NavDropdown.Item
                  href="/story/liked-stories"
                  className="justify-content-end"
                >
                  Liked Stories
                </NavDropdown.Item>
                <NavDropdown.Divider />
                <NavDropdown.Item
                  href="/story/add-story"
                  className="justify-content-end"
                >
                  Add Story
                </NavDropdown.Item>
              </NavDropdown>

              <NavDropdown
                title="Search"
                id="basic-nav-dropdown"
                className="justify-content-end"
              >
                <NavDropdown.Item
                  href="/story/explore" 
                  className="justify-content-end"
                >
                  Explore
                </NavDropdown.Item>
                <NavDropdown.Item
                  href="/story/timeline-search" 
                  className="justify-content-end"
                >
                  Timeline Search
                </NavDropdown.Item>
              </NavDropdown>

              <NavDropdown
                title="My account"
                id="basic-nav-dropdown"
                className="nav-link"
              >
                <NavDropdown.Item
                  href="/user/my-profile"
                  className="justify-content-end"
                >
                  My Profile
                </NavDropdown.Item>
                <NavDropdown.Divider />
                <NavDropdown.Item
                  href="/"
                  onClick={handleLogout}
                  className="justify-content-end"
                >
                  Logout
                </NavDropdown.Item>
              </NavDropdown>
            </>
          ) : (
            <>
              <Nav.Link href="/login" className="nav-link">
                Login
              </Nav.Link>
              <Nav.Link href="/register" className="nav-link">
                Register
              </Nav.Link>
            </>
          )}
        </Container>
      </Navbar>

      <Routes>
        <Route
          path="/"
          element={
            <div className="dutluk-container">
              <QRCode
                errorLevel="H"
                type="svg"
                size={size}
                iconSize={size / 3}
                value="https://drive.google.com/file/d/1CNu4UZIRLdt-MiicpNkl5kSKHmhClR_1/view?usp=drive_link"
                icon="https://imgtr.ee/images/2023/12/03/6a9ea85221f5a50f74baa5578a9a9d3c.jpeg"
              />
            </div>
          }
        />
        <Route path="/user/my-profile" element={<User />} />
        <Route
          path="/login"
          element={<Login onLogin={() => setLoggedIn(true)} />}
        />
        <Route path="/register" element={<Register />} />
        <Route path="/story/add-story" element={<AddStoryForm />} />
        <Route path="/story/edit/:id" element={<EditStoryForm />} />
        <Route path="/story/stashed-stories" element={<StashedStories />} />
        {/* Stash was previous save feature, since naming can be comfusing on the user side 
        wording is changed from "save" to "stash" */}
        <Route path="/story/liked-stories" element={<LikedStories />} />
        <Route path="/story/followings" element={<FollowedUserStories />} />
        <Route path="/story/all-stories" element={<AllStories />} />
        <Route path="/story/:id" element={<StoryDetails />} />
        <Route path="/user/:id" element={<Profile />} />
        <Route path="/story/explore" element={<StorySearch />} />
        {/* Explore was previous search feature, since it applies all filters individualy 
        and add them to same list, wording is changed from "search" to "explore" */}
        <Route path="/story/timeline-search" element={<TimelineSearch />} />
        <Route path="/story/search/label/:label" element={<LabelSearch />} />
        <Route path="/story/recommended" element={<Recommended />} />
      </Routes>
    </Router>
  );
}

export default App;