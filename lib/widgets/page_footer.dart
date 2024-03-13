import 'package:flutter/material.dart';

class PageFooter extends StatelessWidget {
  const PageFooter({
    super.key,
    required this.actionText,
    required this.color,
  });
  final String actionText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 12),
        ),
        TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric())),
          onPressed: () {},
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
