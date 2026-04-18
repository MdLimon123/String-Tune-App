class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String emailVerify = '/auth/otp-verify';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';

  // Calculate
  static const String calculateStringTension = '/users/librarys/';
  static const String library = '/users/librarys/';

  static const String getProfile = "/profiles/me/";

  static const String updateProfile = "/profiles/me/";

  static const String getArtistTunings = "/users/legent-librarys/";
}
