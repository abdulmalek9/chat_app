import 'package:chat_app/constant.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/page_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingUpView extends StatelessWidget {
  const SingUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/Logo.png",
              width: 250,
              height: 250,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "SignUp:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextFormField(
              hintText: "name",
              color: kSecondaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextFormField(
              hintText: "email",
              color: kSecondaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomTextFormField(
              hintText: "password",
              color: kSecondaryColor,
            ),
            const SizedBox(
              height: 12,
            ),
            const CustomTextFormField(
              hintText: "confirm password",
              color: kSecondaryColor,
            ),
            const SizedBox(
              height: 14,
            ),
            const CustomButton(
                buttonTitle: "Sign Up",
                color: kSecondaryColor,
                width: 100,
                height: 35),
            const PageFooter(actionText: "Login", color: kSecondaryColor),
          ],
        ),
      ),
    ));
  }
}
