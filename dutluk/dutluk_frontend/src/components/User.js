import React, { useState, useEffect } from "react";
import { Space, message } from 'antd';
import axios from "axios";
import blankPhotoPreview from "../profile_pic.png";
import Button from 'react-bootstrap/Button';
import "./css/User.css";

function UserComponent({ userId }) {
  const [user, setUser] = useState(null);
  const [photoFile, setPhotoFile] = useState(null);
  const [photoPreview, setPhotoPreview] = useState(blankPhotoPreview);
  const [biography, setBiography] = useState("");
  const [messageApi, contextHolder] = message.useMessage();
  const [isLoading, setLoading] = useState(false);

  useEffect(() => {
    const cookieValue = document.cookie.replace(
      /(?:(?:^|.*;\s*)Bearer\s*=\s*([^;]*).*$)|^.*$/,
      "$1"
    );
    axios.defaults.headers.common["Authorization"] = `Bearer ${cookieValue}`;

    axios
      .get(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/profile`,
        {
          withCredentials: true,
        }
      )
      .then((response) => setUser(response.data))
      .catch((error) => 
      console.log(error.response.data.message));
      messageApi.open({ type: "error", content: "Error occured while loading profile!"});
  }, [messageApi]);

  const handleFileChange = (event) => {
    setPhotoFile(event.target.files[0]);
    setPhotoPreview(URL.createObjectURL(event.target.files[0]));
  };

  const handleBiographyChange = (event) => {
    setBiography(event.target.value);
  };

  const handleBiographySubmit = (event) => {
    event.preventDefault();

    axios
      .post(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/update`,
        { biography },
        { withCredentials: true }
      )
      .then((response) => {
        setUser({ ...user, biography: response.data.biography });
        setBiography("");
      })
      .catch((error) => 
      console.log(error));
      messageApi.open({ type: "error", content: "Error occured while updating your profile!"});
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    const formData = new FormData();
    formData.append("photo", photoFile);
    setLoading(true);

    axios
      .post(
        `${process.env.REACT_APP_BACKEND_URL}/api/user/photo`,
        formData,
        {
          withCredentials: true,
          headers: {
            "Content-Type": "multipart/form-data",
          },
        }
      )
      .then((response) => {
        setUser({ ...user, profilePhoto: response.data.photo });
        setPhotoFile(user.profilePhoto);
        setPhotoPreview(user.profilePhoto);
        setLoading(false);
        messageApi.open({ type: "success", content: "Your photo uploaded!"});
      })
      .catch((error) => 
      console.log(error));
      messageApi.open({ type: "error", content: "Error occured while uploading photo!"});
  };

  if (!user) {
    return <div>Loading...</div>;
  }

  return (
    <Space
      direction="vertical"
      style={{
        width: "100%",
      }}
    >
      {contextHolder}
      <div className="user-component">
        <h2>Username: {user.username}</h2>
        <p>Biography: {user.biography}</p>
        <div>
          <label htmlFor="photo">Photo:</label>
          <p>
            {
              <img
                className="profile-photo"
                src={user.profilePhoto || photoPreview}
                alt={photoPreview}
              />
            }
          </p>
          <form onSubmit={handleSubmit}>
            <input type="file" name="photo" onChange={handleFileChange} />
            <Button
              variant="primary"
              type="submit"
              disabled={isLoading}
              onClick={!isLoading ? handleSubmit : null}
            >
              {isLoading ? 'Loading…' : 'Save photo'}
            </Button>
          </form>
        </div>
        <div>
          <form onSubmit={handleBiographySubmit}>
            <label htmlFor="biography">Biography:</label>
            <input
              type="text"
              name="biography"
              value={biography}
              onChange={handleBiographyChange}
            />
            <button type="submit">Edit Biography</button>
          </form>
        </div>
      </div>
    </Space>
  );
}

export default UserComponent;
