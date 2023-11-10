class NetworkPaths {
  static const String getSamplePost = '/posts';

  // Auth
  static const String login = '/api/mobile/user/login';
  static const String register = '/api/mobile/user/register';
  static const String forgotPassword = '/api/Amobile/uth/ForgotPassword';
  static const String changePassword = '/api/mobile/Auth/ChangePassword';
  static const String logout = '/api/mobile/user/logout';
  static const String profile = '/api/mobile/user/profile';
  static const String checkUser = '/api/mobile/user/checkUser';

  //Story
  static const String getAllStory = '/api/mobile/story/all';
  static const String getActivityFeed = '/api/mobile/story/feed';
  static const String getFallowedStories = '/api/mobile/story/following';
  static const String addStory = '/api/mobile/story/add';
  static const String myStories = '/api/mobile/story/fromUser';
  static const String deleteStory = '/api/mobile/story/delete';
  static const String getStoryDetail = '/api/mobile/story';

  static const String likeStory = '/api/mobile/story/like';
  static const String getLikedStories = '/api/mobile/story/liked';
  static const String getRecent = '/api/mobile/story/recent';

  //Comment
  static const String postComments = '/api/mobile/comment/add';
}
