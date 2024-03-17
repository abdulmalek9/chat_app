import 'package:chat_app/constant.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/page_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({super.key});

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  String username = "", emailForm = "", passwordForm = "", confirmPassword = "";

  SupabaseClient supabase = Supabase.instance.client;
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> signUp() async {
    final email = emailForm;
    final password = passwordForm;

    // Validate form data
    if (formKey.currentState!.validate()) {
      try {
        await supabase.auth.signUp(
            email: email, password: password, data: {'userName': username});
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, 'account_view');
      } on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      } catch (error) {
        // Handle sign-up error (e.g., email already exists)
        print('Sign-up error: $error');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                CustomTextFormField(
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                  onchanged: (data) {
                    username = data;
                  },
                  hintText: "name",
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                  onchanged: (data) {
                    setState(() {
                      emailForm = data;
                    });
                  },
                  hintText: "email",
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                  onchanged: (data) {
                    setState(() {
                      passwordForm = data;
                    });
                  },
                  hintText: "password",
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  onchanged: (data) {
                    confirmPassword = data;
                  },
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Field is required';
                    } else if (data != passwordForm) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  hintText: "confirm password",
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomButton(
                    onTap: () {
                      signUp();
                    },
                    buttonTitle: "Sign Up",
                    color: kSecondaryColor,
                    width: 100,
                    height: 35),
                PageFooter(
                    onPressed: () {
                      Navigator.pushNamed(context, "signin_view");
                    },
                    actionText: "Login",
                    color: kSecondaryColor),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
