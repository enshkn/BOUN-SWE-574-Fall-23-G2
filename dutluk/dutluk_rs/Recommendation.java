public class Recommendation {
    // Diğer alanlar ve fonksiyonlar buraya eklenecek

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