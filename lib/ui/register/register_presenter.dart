import 'package:flutter/material.dart';

import '../../main.dart';
import '../../repository/auth/authentication_repository.dart';
import '../../repository/errors/invalid_credentials_exception.dart';
import '../../repository/user/user_repository.dart';
import '../helpers/navigation/navigation_arguments.dart';
import '../helpers/states/button_state.dart';
import '../helpers/validator/email_validator.dart';
import '../helpers/validator/max_length_validator.dart';
import '../helpers/validator/min_length_validator.dart';

class RegisterPresenter {
  final UserRepository userRepository = UserRepository();
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();

  String name = '';
  final nameErrorNotifier = ValueNotifier<String>('');
  void setName(String name) {
    if (hasMinLength(value: name, size: 3) && hasMaxLength(value: name, size: 12)) {
      nameErrorNotifier.value = '';
    } else {
      nameErrorNotifier.value = 'Nome inválido!';
    }
    this.name = name;
    validateForm();
  }

  String email = '';
  final emailErrorNotifier = ValueNotifier<String>('');
  void setEmail(String email) {
    if (isValidEmail(email: email)) {
      emailErrorNotifier.value = '';
    } else {
      emailErrorNotifier.value = 'Email inválido!';
    }
    this.email = email;
    validateForm();
  }

  String password = '';
  final passwordErrorNotifier = ValueNotifier<String>('');
  void setPassword(String password) {
    if (hasMinLength(value: password, size: 8)) {
      passwordErrorNotifier.value = '';
    } else {
      passwordErrorNotifier.value = 'Senha inválida!';
    }
    this.password = password;
    validateForm();
  }

  final buttonStateNotifier = ValueNotifier<ButtonState>(ButtonState(isLoading: false, isValid: false));
  void validateForm() {
    final isEmailValid = emailErrorNotifier.value.isEmpty && email.isNotEmpty;
    final isPasswordValid = passwordErrorNotifier.value.isEmpty && password.isNotEmpty;
    final isNameValid = nameErrorNotifier.value.isEmpty && name.isNotEmpty;

    buttonStateNotifier.value =
        buttonStateNotifier.value.copyWith(isValid: isEmailValid && isPasswordValid && isNameValid);
  }

  final errorStateNotifier = ValueNotifier<String?>(null);
  Future<void> register() async {
    buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isLoading: true);
    errorStateNotifier.value = null;

    try {
      final user = await authenticationRepository.register(name: name, email: email, password: password);
      await userRepository.saveLocalUser(user: user);
      navigatorNotifier.value = NavigationArguments(route: AppRoutes.homePage);
    } on InvalidCredentialsException {
      errorStateNotifier.value = 'Usuário invalido ou email em uso!';
    }

    buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isLoading: false);
  }

  final navigatorNotifier = ValueNotifier<NavigationArguments?>(null);
  void navigateToLoginPage() {
    navigatorNotifier.value = NavigationArguments(route: AppRoutes.loginPage);
  }
}
