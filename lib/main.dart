import 'package:chat_app/theme.dart';
import 'package:chat_app/views/first_view.dart';
// import 'package:chat_app/views/onboarding.dart';
// import 'package:chat_app/views/signin_view.dart';
// import 'package:chat_app/views/signup_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      home: const FirstView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
