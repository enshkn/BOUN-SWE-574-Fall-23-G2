class NetworkPaths {
  static const String getSamplePost = '/posts';

  // Auth
  static const String login = '/api/user/login';
  static const String register = '/api/user/register';
  static const String logout = '/api/user/logout';
  static const String profile = '/api/user/profile';
  static const String checkUser = '/api/user/checkUser';
  static const String profileUpdate = '/api/user/update';

  //Story
  static const String getAllStory = '/api/story/all';
  static const String getActivityFeed = '/api/story/feed';
  static const String getFallowedStories = '/api/story/following';
  static const String addStory = '/api/story/add';
  static const String myStories = '/api/story/fromUser';
  static const String deleteStory = '/api/story/delete';
  static const String getStoryDetail = '/api/story';

  static const String likeStory = '/api/story/like';
  static const String getLikedStories = '/api/story/liked';
  static const String getRecent = '/api/story/recent';

  //Comment
  static const String postComments = '/api/comment/add';
}
