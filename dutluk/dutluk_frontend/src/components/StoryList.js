const StoryList = ({ story, children }) => {
    return (
        <div key={story.id} className="story">
            <h2 className="story-title">
                <a href={"/story/" + story.id}>{story.title}</a>
            </h2>
            <p className="story-details">
                <b>Likes:</b> {story.likes ? story.likes.length : 0}
            </p>
            <p className="story-details">
                <b>Labels:</b>{" "}
                {story.labels.map((label, index) => (
                    <span key={index}>
                        <a href={"/story/search/label/" + label}>{label}</a>
                        {index < story.labels.length - 1 && ", "}
                    </span>
                ))}
            </p>
            <p className="story-details">
                <b>Written by:</b>{" "}
                <a href={"/user/" + story.user.id}>{story.user.username}</a>
            </p>

            {story.startTimeStamp && (
                <p className="story-details">
                    <b>Start Date:</b> {story.startTimeStamp}
                </p>
            )}
            {story.endTimeStamp && (
                <p className="story-details">
                    <b>End Date:</b> {story.endTimeStamp}
                </p>
            )}
            {story.season && (
                <p className="story-details">
                    <b>Season:</b> {story.season}
                </p>
            )}
            {story.decade && (
                <p className="story-details">
                    <b>Decade:</b> {story.decade}
                </p>
            )}

            <p className="story-details">
                <b>Published at:</b> {story.createdAt}
            </p>

            <p className="story-details">
                <b>Locations:</b>
            </p>
            <ul className="locations-list">
                {story.locations.map((location) => (
                    <li key={location.id}>{location.locationName}</li>
                ))}
            </ul>
         {children}
        </div>
    );
};
/*function formatDate(dateString) {
    const date = new Date(dateString);
    const day = date.getDate();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const hours = date.getHours();
    const minutes = date.getMinutes().toString().padStart(2, "0");

    const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;

    return formattedDate;
  }*/
  
export default StoryList;