import "./css/StoryList.css";
import axios from "axios";
import { useState, useEffect, useCallback } from "react";
import { Space, message } from 'antd';

const StoryList = ({ story }) => {
    const [isSaved, setIsSaved] = useState(false);
    const [messageApi, contextHolder] = message.useMessage();
    const currentUserId = sessionStorage.getItem('currentUserId');

    const fetchSaveStatus = useCallback(async () => {
        try {
            const response = await axios.get(
                `${process.env.REACT_APP_BACKEND_URL}/api/story/isSavedByUser/${story.id}`,
                {
                    withCredentials: true,
                }
            );
            setIsSaved(response.data);
        } catch (error) {
            console.error('Save status API error:', error.message);
            messageApi.open({ type: "error", content: "Error occurred while fetching saved story data!" });
        }
    }, [story.id, messageApi]);

    useEffect(() => {
        fetchSaveStatus();
    }, [fetchSaveStatus]);

    const truncateText = (text, maxLength) => {
        if (text.length > maxLength) {
            return {
                mainText: text.substring(0, maxLength),
                fadeText: text.substring(maxLength)
            };
        }
        return { mainText: text, fadeText: '' };
    };

    const { mainText, fadeText } = truncateText(story.text, 95); // Adjust 100 to your desired length

    const handleSaveClick = async () => {
        try {
            const response = await axios.post(
                `${process.env.REACT_APP_BACKEND_URL}/api/story/save`,
                { savedEntityId: story.id },
                {
                    withCredentials: true,
                }
            );
            setIsSaved(!isSaved); // Toggle the save status
            console.log(response); // Log the response to check if it's as expected
            if (isSaved === true) {
                messageApi.open({ type: "success", content: "You unsaved the story" });
            } else if (isSaved === false) {
                messageApi.open({ type: "success", content: "You saved the story" });
            }
        } catch (error) {
            console.error(error);
        }
    };

    const handleDeleteStory = async (storyId) => {
        axios
        .get(
            `${process.env.REACT_APP_BACKEND_URL}/api/story/delete/${storyId}`,
            {
              withCredentials: true,
            }
          )
          .then(() => {
            window.location.reload(); 
          })
          .catch((error) => {
            console.log(error);
            messageApi.open({ type: "error", content: "Error occured while deleting the story!"});
          });
    };

    return (
        <Space
            direction="vertical"
            align="center"
            style={{
                width: '100%',
            }}
        >
            {contextHolder}
            <div className="story-item">
                <div className="story-header">
                    <img src={story.user.profilePhoto} className="profile-picture" alt="profile-pic" />
                    <div className="story-info">
                        <a href={`/user/${story.user.id}`} className="username">@{story.user.username}</a>
                        <span className="story-date">Posted: {story.createdAt}</span>
                    </div>
                    <div className="percentage">
                        {story.percentage && (
                            <p>{`Recommended: ${story.percentage}`}</p>
                        )}
                    </div>
                </div>
                <h2><a href={`/story/${story.id}`} className="story-title">{story.title}</a></h2>

                <div className="location-container">
                    <span className="location-pin">📍</span>
                    <span className="location-text">{story.locations[0].locationName}</span>
                </div>

                {story.picture && <img src={story.picture} alt="Post" />}

                <div className="text-container">
                    <p className="main-text">{mainText}</p>
                    <p className="fade-out-text">{fadeText}</p>
                </div>


                <div className="tag-interaction-container">
                    <div className="tags">
                        {story.labels.map((tag, idx) => (
                            <span key={idx} className="tag">{tag}</span>
                        ))}
                    </div>

                    <div className="interactions">
                        <button onClick={handleSaveClick} style={{ backgroundColor: "#ff5500ca", color: "white", border: "none", margin: "20px" }} type="submit" className="btn btn-primary">
                            {isSaved ? 'Unsave' : 'Save'}
                        </button>
                        {story.user.id == currentUserId && (
                            <button
                                className="btn btn-danger"
                                style={{ marginRight: '10px' }} // Add some space between the buttons
                                onClick={() => handleDeleteStory(story.id)}
                            >Delete</button>)
                        }
                        <span>{story.likes ? story.likes.length : 0}❤️</span>
                        <span>{story.comments ? story.comments.length : 0}💬</span>
                    </div>
                </div>


                <div className="date-information">
                    {story.startTimeStamp && <span className="date">Start: {story.startTimeStamp}</span>}
                    {story.endTimeStamp && <span className="date">End: {story.endTimeStamp}</span>}
                    {story.season && <span className="date">Season: {story.season}</span>}
                    {story.decade && <span className="date">Decade: {story.decade}</span>}
                    {story.endDecade && <span className="date">End Decade: {story.endDecade}</span>}
                    {/* You can add more conditional renders for other date fields as needed */}
                </div>

            </div>
        </Space>
    );
};


export default StoryList;