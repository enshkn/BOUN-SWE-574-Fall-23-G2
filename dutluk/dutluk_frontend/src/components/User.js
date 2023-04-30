import React, { useState, useEffect } from "react";
import axios from "axios";

function UserComponent({ userId }) {
  const [user, setUser] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    axios
      .get(`http://localhost:8080/api/user/${userId}`)
      .then((response) => setUser(response.data))
      .catch((error) => setError(error.response.data.message));
  }, [userId]);

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <div>
      {user && (
        <div>
          <h2>{user.username}</h2>
          <p>{user.email}</p>
        </div>
      )}
    </div>
  );
}

export default UserComponent;
