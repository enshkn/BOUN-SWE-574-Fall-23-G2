class NetworkPaths {
  static const String getSamplePost = '/posts';

  // Auth
  static const String login = '/api/user/login';
  static const String register = '/api/user/register';
  static const String forgotPassword = '/api/Auth/ForgotPassword';
  static const String changePassword = '/api/Auth/ChangePassword';
  static const String logout = '/api/user/logout';
  static const String profile = '/api/user/profile';
  static const String checkUser = '/api/user/checkUser';

  //Story
  static const String getAllStory = '/api/story/all';
  static const String getActivityFeed = '/api/story/feed';
  static const String getFallowedStories = '/api/story/following';
}
