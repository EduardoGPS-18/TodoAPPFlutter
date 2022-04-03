import 'package:flutter/material.dart';

import '../shared/components/texts/title_text.dart';
import 'splash_presenter.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.navigatorNotifier.addListener(() {
      final navArguments = widget.presenter.navigatorNotifier.value;
      if (navArguments != null && navArguments.route.isNotEmpty == true) {
        Navigator.of(context).pushReplacementNamed(navArguments.route);
      }
    });
    widget.presenter.getInitialRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: TitleText(
            text: 'TODO APP',
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
