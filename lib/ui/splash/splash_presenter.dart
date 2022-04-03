import 'package:flutter/material.dart';

import '../../main.dart';
import '../../repository/user/user_repository.dart';
import '../helpers/navigation/navigation_arguments.dart';

class SplashPresenter {
  final userRepository = UserRepository();

  Future<void> getInitialRoute() async {
    final user = await userRepository.getLocalUser();
    await Future.delayed(const Duration(seconds: 2));
    if (user?.token != null) {
      navigateToHomePage();
    } else {
      navigateToLoginPage();
    }
  }

  final navigatorNotifier = ValueNotifier<NavigationArguments?>(null);
  void navigateToHomePage() {
    navigatorNotifier.value = NavigationArguments(route: AppRoutes.homePage);
  }

  void navigateToLoginPage() {
    navigatorNotifier.value = NavigationArguments(route: AppRoutes.loginPage);
  }
}
