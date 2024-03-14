import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/page_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                "assets/Logo.png",
                width: 250,
                height: 250,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Login:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const CustomTextFormField(
                hintText: "Email",
              ),
              const SizedBox(
                height: 12,
              ),
              const CustomTextFormField(hintText: "Password"),
              const SizedBox(height: 18),
              CustomButton(
                width: 100,
                height: 34,
                buttonTitle: "Login",
                color: Theme.of(context).primaryColor,
              ),
              PageFooter(
                actionText: "Sign Up",
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
