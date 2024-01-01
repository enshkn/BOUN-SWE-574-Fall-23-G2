import "./css/StoryList.css";
import axios from "axios";
import { useState, useEffect, useCallback } from "react";
import { Space, message } from 'antd';
import { useNavigate } from "react-router-dom";

// Save feauture name was changed to stash in order to avoid confusion on the user side.

const StoryList = ({ story }) => {
    const [isSaved, setIsSaved] = useState(false);
    const [messageApi, contextHolder] = message.useMessage();
    const currentUserId = sessionStorage.getItem('currentUserId');
    const navigate = useNavigate();

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
            console.error('Stash(Save) status API error:', error.message);
            messageApi.open({ type: "error", content: "Error occurred while fetching stashed story data!" });
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
            setIsSaved(!isSaved);
            console.log(response);
            if (isSaved === true) {
                messageApi.open({ type: "success", content: "You unstashed the story" });
            } else if (isSaved === false) {
                messageApi.open({ type: "success", content: "You stashed the story" });
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

    const handleEditStory = (storyId) => {
            navigate(`/story/edit/${storyId}`);
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
                            <p>{`Recommended: ${story.percentage} %`}</p>
                        )}
                    </div>
                </div>
                <h2><a href={`/story/${story.id}`} className="story-title">{story.title}</a></h2>

                <div className="location-container">
                    <span className="location-pin">📍</span>
                    <span className="location-text">{story.locations[0].locationName}</span>
                </div>

                <img src={story.picture || 'https://images.unsplash.com/photo-1682687220063-4742bd7fd538?q=80&w=1375&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'} alt="Post" />

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
                        <button onClick={handleSaveClick} style={{ backgroundColor: "#ff5500ca", color: "white", border: "none"}} type="submit" className="btn btn-primary">
                            {isSaved ? 'Unstash' : 'Stash'}
                        </button>
                        {story.user.id == currentUserId && (
                            <button
                                style={{ backgroundColor: "#ff5500ca", color: "white", border: "none", margin: "10px" }}
                                className="btn btn-primary"
                                onClick={() => handleEditStory(story.id)}
                            >Update</button>)
                        }
                        {story.user.id == currentUserId && (
                            <button
                                className="btn btn-danger"
                                style={{ marginRight: '10px' }}
                                onClick={() => handleDeleteStory(story.id)}
                            >Delete</button>)
                        }
                        <span>{story.likeSize ? story.likeSize : 0}❤️</span>
                        <span>{story.commentSize ? story.commentSize : 0}💬</span>
                    </div>
                </div>


                <div className="date-information">
                {story.verbalExpression != null ? (
                    <   span className="story-date">{story.verbalExpression}</span>
                ) : (
                <>
                    {story.startTimeStamp && <span className="story-date">Start: {story.startTimeStamp}</span>}
                    {story.endTimeStamp && <span className="story-date">End: {story.endTimeStamp}</span>}
                    {story.season && <span className="story-date">Season: {story.season}</span>}
                    {story.endSeason && <span className="story-date">Season: {story.endSeason}</span>}
                    {story.decade && <span className="story-date">Decade: {story.decade}</span>}
                    {story.endDecade && <span className="story-date">End Decade: {story.endDecade}</span>}
                    {/* You can add more conditional renders for other date fields as needed */}
                </>
                )}
                </div>

            </div>
        </Space>
    );
};


export default StoryList;