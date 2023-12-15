import "./css/StoryList.css";


const truncateText = (text, maxLength) => {
    if (text.length > maxLength) {
        return {
            mainText: text.substring(0, maxLength),
            fadeText: text.substring(maxLength)
        };
    }
    return { mainText: text, fadeText: '' };
};

const formatDate = (timestamp) => {
    return timestamp ? new Date(timestamp).toLocaleDateString() : '';
  };


const StoryList = ({ story }) => {

    const { mainText, fadeText } = truncateText(story.text, 95); // Adjust 100 to your desired length
    return (
        <div className="story-item">
            <div className="story-header">
                <img src={story.user.profilePhoto} className="profile-picture" />
                <div className="story-info">
                    <a href={`/user/${story.user.id}`} className="username">@{story.user.username}</a>
                    <span className="story-date">Posted: {story.createdAt}</span>
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
                    <span>{story.likes ? story.likes.length : 0}❤️</span>
                    <span>{story.comments ? story.comments.length : 0}💬</span>
                </div>
            </div>


            <div className="date-information">
                {story.startTimeStamp && <span className="date">Start: {formatDate(story.startTimeStamp)}</span>}
                {story.endTimeStamp && <span className="date">End: {formatDate(story.endTimeStamp)}</span>}
                {story.season && <span className="date">Season: {story.season}</span>}
                {story.decade && <span className="date">Decade: {story.decade}</span>}
                {story.endDecade && <span className="date">End Decade: {story.endDecade}</span>}
                {/* You can add more conditional renders for other date fields as needed */}
            </div>

        </div>
    );
};


export default StoryList;