import 'package:flutter/material.dart';

import '../helpers/states/button_state.dart';
import '../shared/components/button/primary_button_expanded.dart';
import '../shared/components/cards/card_with_custom_padding.dart';
import '../shared/components/texts/title_text.dart';
import 'register_presenter.dart';

class RegisterPage extends StatefulWidget {
  final RegisterPresenter presenter;

  const RegisterPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.navigatorNotifier.addListener(() {
      final navArguments = widget.presenter.navigatorNotifier.value;
      if (navArguments != null && navArguments.route.isNotEmpty == true) {
        Navigator.of(context).pushReplacementNamed(navArguments.route);
      }
    });
    widget.presenter.errorStateNotifier.addListener(() {
      final error = widget.presenter.errorStateNotifier.value;
      if (error?.isNotEmpty == true) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
          padding: const EdgeInsets.all(24),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: constraints,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * .3,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(child: TitleText(text: 'Todo APP')),
                      ),
                    ),
                    CardWithCustomPadding(
                      child: Column(
                        children: [
                          const TitleText(text: 'LOGIN', fontSize: 24),
                          const SizedBox(height: 46),
                          ValueListenableBuilder<String>(
                            valueListenable: widget.presenter.nameErrorNotifier,
                            builder: (_context, nameError, _child) => TextField(
                              onChanged: widget.presenter.setName,
                              decoration: InputDecoration(
                                labelText: 'Nome',
                                hintText: 'Nome Sobrenome',
                                errorText: nameError.isNotEmpty ? nameError : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ValueListenableBuilder<String>(
                            valueListenable: widget.presenter.emailErrorNotifier,
                            builder: (_context, emailError, _child) => TextField(
                              onChanged: widget.presenter.setEmail,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                hintText: 'endereco@mail.com ',
                                errorText: emailError.isNotEmpty ? emailError : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ValueListenableBuilder<String>(
                            valueListenable: widget.presenter.passwordErrorNotifier,
                            builder: (_context, passwordError, _child) {
                              return TextField(
                                onChanged: widget.presenter.setPassword,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  hintText: '*********',
                                  errorText: passwordError.isNotEmpty ? passwordError : null,
                                ),
                                obscureText: true,
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                          ValueListenableBuilder<ButtonState>(
                            valueListenable: widget.presenter.buttonStateNotifier,
                            builder: (_context, buttonState, _child) {
                              final isLoading = buttonState.isLoading;
                              final isValid = buttonState.isValid;

                              void closeKeyboardAndLoginUser() {
                                FocusScope.of(context).unfocus();
                                widget.presenter.register();
                              }

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PrimaryButtonExpanded(
                                    text: 'Entrar',
                                    isLoading: isLoading,
                                    onPressed: isLoading || !isValid ? null : closeKeyboardAndLoginUser,
                                  ),
                                  TextButton(
                                    child: const Text('Ainda não sou cadastrado!'),
                                    onPressed: isLoading ? null : widget.presenter.navigateToLoginPage,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight * .1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
