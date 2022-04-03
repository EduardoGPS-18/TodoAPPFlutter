import '../errors/invalid_session_exception.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }

  factory UserModel.fromApiMap(Map<String, dynamic> map) {
    if (map['session'] == null) {
      throw InvalidSessionException();
    }
    return UserModel(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['session'] ?? '',
    );
  }

  factory UserModel.fromLocalMap(Map<String, dynamic> map) {
    if (map['token'] == null) {
      throw InvalidSessionException();
    }
    return UserModel(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
    );
  }
}
