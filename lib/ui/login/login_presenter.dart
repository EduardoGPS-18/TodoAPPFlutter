import 'package:flutter/material.dart';

import '../../main.dart';
import '../../repository/auth/authentication_repository.dart';
import '../../repository/errors/invalid_credentials_exception.dart';
import '../../repository/user/user_repository.dart';
import '../helpers/navigation/navigation_arguments.dart';
import '../helpers/states/button_state.dart';
import '../helpers/validator/email_validator.dart';
import '../helpers/validator/min_length_validator.dart';

class LoginPresenter {
  final UserRepository userRepository = UserRepository();
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();

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
    if (hasMinLength(value: password, size: 6)) {
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

    buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isValid: isEmailValid && isPasswordValid);
  }

  final errorStateNotifier = ValueNotifier<String?>(null);
  Future<void> login() async {
    buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isLoading: true);
    errorStateNotifier.value = null;

    try {
      final user = await authenticationRepository.login(email: email, password: password);
      await userRepository.saveLocalUser(user: user);
      navigatorNotifier.value = NavigationArguments(route: AppRoutes.homePage);
    } on InvalidCredentialsException {
      errorStateNotifier.value = 'Credenciais inválidas!';
    }

    buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isLoading: false);
  }

  final navigatorNotifier = ValueNotifier<NavigationArguments?>(null);
  void navigateToRegisterPage() {
    navigatorNotifier.value = NavigationArguments(route: AppRoutes.registerPage);
  }
}
