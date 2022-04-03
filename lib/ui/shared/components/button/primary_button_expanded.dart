import 'package:flutter/material.dart';

class PrimaryButtonExpanded extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const PrimaryButtonExpanded({
    Key? key,
    required this.text,
    required this.isLoading,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
            child: isLoading
                ? SizedBox(
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                : Text(text),
          ),
        ],
      ),
    );
  }
}
