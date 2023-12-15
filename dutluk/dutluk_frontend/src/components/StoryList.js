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


const StoryList = ({ story }) => {

    const { mainText, fadeText } = truncateText(story.text, 20); // Adjust 100 to your desired length
    return (
        <div className="story-item">
            <h2><a href={`/story/${story.id}`} className="story-title">{story.title}</a></h2>
            <a href={`/user/${story.user.id}`} className="user-ref">@{story.user.username}</a>

            {story.picture && <img src={story.picture} alt="Post" />}

            <div className="text-container">
                <p className="main-text">{mainText}</p>
                <p className="fade-out-text">{fadeText}</p>
            </div>

            <div className="dates">
                <span>Posted: {story.createdAt}</span>
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

        </div>
    );
};


export default StoryList;