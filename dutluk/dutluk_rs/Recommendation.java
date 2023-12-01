public class Recommendation {
    // call this function when a story is created
    public void vectorizeStory(Story story) {
    // when a story is created by an user grap the story body, tags, title into a string variable then assign it a variable with name "textToSend"
    // create a JSON object with key "text"  then assign the variable textToSend into it.
    // send JSON object to RE server (async)
    // grap the return vectorized version of the story and assign a variable with name vectorizedStory
    // assign vectorizedStory to the attribute of Story with name vectorized
    };

    // call this function when a user liked a story
    public void storyLiked(Story story, User user) {
        // fetch the vectorized story attribute from the story object then assign it to a variable call vectorizedStory
        // fetch the the user-taste attribute from the user object then assign it to a variable call userTaste
        // fetch the total liked stories from the user object then assign it to a variable call userWeight
        // add the vectorized story to the user-taste vector with considering the userWeight then assign it to a variable call updatedTaste
        // change user-taste attribute with updatedTaste
        // add 1 to the userWeight
    };

    // call this function when a user unliked a story
    public void storyUnliked(Story story, User user) {
        // fetch the vectorized story attribute from the story object then assign it to a variable call vectorizedStory
        // fetch the the user-taste attribute from the user object then assign it to a variable call userTaste
        // fetch the total liked stories from the user object then assign it to a variable call userWeight
        // subscript the vectorized story from the user-taste vector with considering the userWeight then assign it to a variable call updatedTaste
        // change user-taste attribute with updatedTaste
        // subscript 1 from the userWeight

    };

}