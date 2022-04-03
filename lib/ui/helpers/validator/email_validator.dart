bool isValidEmail({required String email}) {
  final emailRegexp = RegExp('^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+\$');
  return emailRegexp.hasMatch(email);
}
