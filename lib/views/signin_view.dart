import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/page_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  // final bool _isLoading = false;
  bool _redirecting = false;
  // late final TextEditingController _emailController = TextEditingController();
  String emailForm = "", passwordForm = "";
  GlobalKey<FormState>? formKey = GlobalKey();
  late final StreamSubscription<AuthState> _authStateSubscription;
  SupabaseClient supabase = Supabase.instance.client;
  Future<void> signIn() async {
    final email = emailForm;
    final password = passwordForm;

    // Validate form data
    if (formKey!.currentState!.validate()) {
      try {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
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
          const SnackBar(content: Text('Sign-in failed. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    // _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
    super.initState();
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    onchanged: (data) {
                      setState(() {
                        emailForm = data;
                      });
                    },
                    hintText: "Email",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    hintText: "Password",
                    onchanged: (data) {
                      setState(() {
                        passwordForm = data;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    onTap: () async {
                      signIn();
                    },
                    width: 100,
                    height: 34,
                    buttonTitle: "Login",
                    color: Theme.of(context).primaryColor,
                  ),
                  PageFooter(
                    onPressed: () {
                      Navigator.pushNamed(context, "signup_view");
                    },
                    actionText: "Sign Up",
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
