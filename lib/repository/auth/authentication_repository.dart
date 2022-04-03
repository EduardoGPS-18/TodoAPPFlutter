import 'dart:convert';

import 'package:http/http.dart';

import '../../models/errors/invalid_session_exception.dart';
import '../../models/user/user_model.dart';
import '../api/get_api_url.dart';
import '../errors/invalid_credentials_exception.dart';

class AuthenticationRepository {
  final Client client;
  AuthenticationRepository() : client = Client();

  Future<UserModel> login({required String email, required String password}) async {
    final uri = Uri.parse('$getApiUrl/user/login');
    final toSendBody = {'email': email, 'password': password};
    final headers = {'Content-Type': 'application/json'};

    final jsonResponse = await client.post(uri, body: jsonEncode(toSendBody), headers: headers);
    final body = jsonDecode(jsonResponse.body);

    final UserModel user;
    try {
      user = UserModel.fromApiMap(body as Map<String, dynamic>);
    } on InvalidSessionException {
      throw InvalidCredentialsException();
    }
    return user;
  }

  Future<UserModel> register({required String name, required String email, required String password}) async {
    final uri = Uri.parse('$getApiUrl/user/register');
    final toSendBody = {'name': name, 'email': email, 'password': password};
    final headers = {'Content-Type': 'application/json'};

    final jsonResponse = await client.post(uri, body: jsonEncode(toSendBody), headers: headers);
    final body = jsonDecode(jsonResponse.body);

    final UserModel user;
    try {
      user = UserModel.fromApiMap(body as Map<String, dynamic>);
    } on InvalidSessionException {
      throw InvalidCredentialsException();
    }
    return user;
  }
}
