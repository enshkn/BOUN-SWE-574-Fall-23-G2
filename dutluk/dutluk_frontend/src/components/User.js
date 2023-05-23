import React, { useState, useEffect } from "react";
import axios from "axios";
import "./css/User.css";

function UserComponent({ userId }) {
  const [user, setUser] = useState(null);
  const [error, setError] = useState("");
  const [photoFile, setPhotoFile] = useState(null);
  const [photoPreview, setPhotoPreview] = useState(null);
  const [biography, setBiography] = useState("");
  const BACKEND_URL = "host.docker.internal";

  useEffect(() => {
    const cookieValue = document.cookie.replace(
      /(?:(?:^|.*;\s*)Bearer\s*=\s*([^;]*).*$)|^.*$/,
      "$1"
    );
    axios.defaults.headers.common["Authorization"] = `Bearer ${cookieValue}`;

    axios
      .get("http://" + BACKEND_URL + ":8080/api/user/profile", {
        withCredentials: true,
      })
      .then((response) => setUser(response.data))
      .catch((error) => setError(error.response.data.message));
  }, []);

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
        "http://" + BACKEND_URL + ":8080/api/user/update",
        { biography },
        { withCredentials: true }
      )
      .then((response) => {
        setUser({ ...user, biography: response.data.biography });
        setBiography("");
      })
      .catch((error) => console.log(error));
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    const formData = new FormData();
    formData.append("photo", photoFile);

    axios
      .post("http://" + BACKEND_URL + ":8080/api/user/photo", formData, {
        withCredentials: true,
        headers: {
          "Content-Type": "multipart/form-data",
        },
      })
      .then((response) => {
        setUser({ ...user, profilePhoto: response.data.photo });
        setPhotoFile(user.profilePhoto);
        setPhotoPreview(user.profilePhoto);
      })
      .catch((error) => console.log(error));
  };

  if (error) {
    return <div>{error}</div>;
  }

  if (!user) {
    return <div>Loading...</div>;
  }

  return (
    <div className="user-component">
      <h2>Username: {user.username}</h2>
      <p>Biography: {user.biography}</p>
      <div>
        <label htmlFor="photo">Photo:</label>
        <img
          className="user-photo"
          src={photoPreview || `data:image/jpeg;base64,${user.profilePhoto}`}
          alt={user.username}
        />
        <form onSubmit={handleSubmit}>
          <input type="file" name="photo" onChange={handleFileChange} />
          <button type="submit">Save Photo</button>
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
  );
}

export default UserComponent;
