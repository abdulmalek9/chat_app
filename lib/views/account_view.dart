import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});
  final SupabaseClient supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Hello",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: IconButton(
                onPressed: () {
                  supabase.auth.signOut().then((value) =>
                      Navigator.pushReplacementNamed(context, 'signin_view'));
                },
                icon: const Icon(Icons.logout_outlined)),
          ),
        ],
      ),
    ));
  }
}
