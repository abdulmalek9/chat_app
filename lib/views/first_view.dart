import 'package:chat_app/constant.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.,
          children: [
            Image.asset(
              "assets/Logo.png",
              width: 250,
              height: 250,
            ),
            const SizedBox(
              height: 14,
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, "signin_view");
                },
                buttonTitle: "Sign In",
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width,
                height: 40),
            const SizedBox(
              height: 14,
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, "signup_view");
                },
                buttonTitle: "Sign Up",
                color: kSecondaryColor,
                width: MediaQuery.of(context).size.width,
                height: 40),
          ],
        ),
      ),
    ));
  }
}
