import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route} from "react-router-dom";
import "./App.css";
import DutlukImage from "./dutlukfinal_1.jpg";
import DutlukLogo from "./dutluk_logo.png";
import User from "./components/User";
import Profile from "./components/Profile";
import Login from "./components/Login";
import Register from "./components/Register";
import AddStoryForm from "./components/AddStory";
import EditStoryForm from "./components/EditStory";
import SavedStories from "./components/SavedStories";
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
import Paragraph from "antd/es/skeleton/Paragraph";
import { FileTextOutlined } from '@ant-design/icons';


function App() {
  const [loggedIn, setLoggedIn] = useState(false);
  const [size] = useState(600);

  useEffect(() => {
    axios
      .get(`${process.env.REACT_APP_BACKEND_URL}/api/user/profile`, {
        withCredentials: true,
      })
      .then((response) => {
        setLoggedIn(true);
      })
      .catch((error) => {
        setLoggedIn(false);
      });
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
              <Nav.Link href="/story/followings" className="nav-link">
                Story Feed
              </Nav.Link>
              <Nav.Link href="/story/recommended" className="nav-link">
                Recommended Stories
              </Nav.Link>
              <Nav.Link href="/story/all-stories" className="nav-link">
                All Stories
              </Nav.Link>
              <Nav.Link href="/story/explore" className="nav-link">
                Explore
              </Nav.Link>
              <Nav.Link href="/story/timeline-search" className="nav-link">
                Timeline Search
              </Nav.Link>
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
                <NavDropdown.Item
                  href="/story/saved-stories"
                  className="justify-content-end"
                >
                  Saved Stories
                </NavDropdown.Item>
                <NavDropdown.Item
                  href="/story/add-story"
                  className="justify-content-end"
                >
                  Add Story
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
        <Route path="/story/saved-stories" element={<SavedStories />} />
        <Route path="/story/followings" element={<FollowedUserStories />} />
        <Route path="/story/all-stories" element={<AllStories />} />
        <Route path="/story/:id" element={<StoryDetails />} />
        <Route path="/user/:id" element={<Profile />} />
        <Route path="/story/explore" element={<StorySearch />} />
        {/* Explore was previous search feature, sisnce it applies all filters individualy 
        and add them to same list, wording is changed from "search" to "explore" */}
        <Route path="/story/timeline-search" element={<TimelineSearch />} />
        <Route path="/story/search/label/:label" element={<LabelSearch />} />
        <Route path="/story/recommended" element={<Recommended />} />
      </Routes>
    </Router>
  );
}

export default App;