import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/user/user_model.dart';

class UserRepository {
  final FlutterSecureStorage secureStorage;
  UserRepository() : secureStorage = const FlutterSecureStorage();

  Future<void> saveLocalUser({required UserModel user}) async {
    await secureStorage.write(key: 'currentUser', value: jsonEncode(user.toLocalMap()));
  }

  Future<UserModel?> getLocalUser() async {
    final userJson = await secureStorage.read(key: 'currentUser');
    if (userJson == null) return null;

    final userMap = jsonDecode(userJson);
    return UserModel.fromLocalMap(userMap);
  }

  Future<void> removeLocalUser() async {
    return secureStorage.delete(key: 'currentUser');
  }
}
