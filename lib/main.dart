import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'ui/home/home_page.dart';
import 'ui/home/home_presenter.dart';
import 'ui/login/login_page.dart';
import 'ui/login/login_presenter.dart';
import 'ui/register/register_page.dart';
import 'ui/register/register_presenter.dart';
import 'ui/shared/theme/app_theme.dart';
import 'ui/splash/splash_page.dart';
import 'ui/splash/splash_presenter.dart';
import 'ui/task_details/task_details_page.dart';
import 'ui/task_details/task_details_presenter.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class AppRoutes {
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String homePage = '/home';
  static const String splashPage = '/splash';
  static const String taskDetailsPage = '/task-details';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo APP',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashPage,
      routes: {
        AppRoutes.splashPage: (context) => SplashPage(presenter: SplashPresenter()),
        AppRoutes.loginPage: (context) => LoginPage(presenter: LoginPresenter()),
        AppRoutes.registerPage: (context) => RegisterPage(presenter: RegisterPresenter()),
        AppRoutes.homePage: (context) => HomePage(presenter: HomePresenter()),
        AppRoutes.taskDetailsPage: (context) => TaskDetailsPage(presenter: TaskDetailsPresenter()),
      },
    );
  }
}
