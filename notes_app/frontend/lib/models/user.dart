import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../enums/method_type.dart';
import '../utils/api_utils.dart';

class User {
  static final User _user = User._internal();
  late SharedPreferences sharedPreferences;
  factory User() {
    return _user;
  }

  User._internal();
  String email = '', token = '';

  Future<bool> signIn(String password) async {
    Response response = await post(
        Uri.parse('http://127.0.0.1:8000/auth/login/'),
        body: {"username": email, "password": password});
    if ([200, 201, 202].contains(response.statusCode)) {
      var json = jsonDecode(response.body);
      token = json['token'];
      await sharedPreferences.setString('token', token);
      return true;
    }
    return false;
  }

  Future<String?> signUp(String password) async {
    Response response = await post(
        Uri.parse('http://127.0.0.1:8000/auth/register/'),
        body: {"email": email, "password": password});
    // print(response.body);
    var json = jsonDecode(response.body);
    if (ApiConstants.successCodes.contains(response.statusCode)) {
      token = json['token'];
      return null;
    }
    return jsonDecode(response.body)['email'][0].toString();
  }

  Future<bool> logout() async {
    bool res = await sharedPreferences.remove('token');
    if (res) {
      token = '';
    }
    return res;
  }

  Future<String?> changePassword(String oldPassword, String newPassword) async {
    Response response = await makeApiCall(
      ApiConstants.changePasswordUrl,
      MethodType.post,
      body: {'old_password': oldPassword, 'new_password': newPassword},
    );
    // print(response.body);
    if (ApiConstants.successCodes.contains(response.statusCode)) {
      return null;
    }
    String msg = response.statusCode == 404
        ? 'User does not exist.'
        : jsonDecode(response.body)['msg'] ?? '';
    return msg;
  }

  forgotPassword() async {}
}
