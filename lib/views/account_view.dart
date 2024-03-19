import 'package:chat_app/widgets/conntact_widget.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Chats",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () async {
                await supabase.auth.signOut();
                Navigator.pushReplacementNamed(context, 'signin_view');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => const ContactWidget(
          image: "assets/majed.jpg",
          name: "Majed",
          lastmessage: "Hello, Do you wanna build a snow man?",
        ),
        itemCount: 2,
      ),
    ));
  }
}
