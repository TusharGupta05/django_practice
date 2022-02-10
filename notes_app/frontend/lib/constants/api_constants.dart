class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String _auth = '$baseUrl/auth';
  static const String loginUrl = '$_auth/login/';
  static const String forgotPasswordUrl = '$_help/forgot-password/';
  static const String changePasswordUrl = '$_help/change-password/';
  static const String registerUrl = '$_auth/register/';
  static const String notesList = '$baseUrl/notes/';
  static const String _help = '$baseUrl/help';
  static const List<int> successCodes = [200, 201, 202];
}
