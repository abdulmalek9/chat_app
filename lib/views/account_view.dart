import 'package:chat_app/models/contact_model.dart';
import 'package:chat_app/supabase/supabase_class.dart';
import 'package:chat_app/widgets/conntact_widget.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? info;
  List<ContactModel> conntact = [];
  dynamic contact_id;
  Future<bool> cheackIfExist(String email) async {
    try {
      final response =
          await supabase.from('profiles').select('id').eq('email', email);

      if (response.isEmpty) {
        return false;
      } else {
        setState(() {
          contact_id = response[0]['id'];
        });
        print("id = = = = = = = $contact_id");
        return true;
      }
    } catch (e) {
      return false;
    }

    // print("object======================== $response");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await openDialog(context);
        },
        child: const Icon(Icons.group_add_rounded),
      ),
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
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, 'signin_view');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => ContactWidget(
          image: "assets/majed.jpg",
          name: conntact[i].name!,
          lastmessage: "Hello, Do you wanna build a snow man?",
        ),
        itemCount: conntact.isEmpty ? 0 : conntact.length,
      ),
    ));
  }

  openDialog(context) {
    String? name, email;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add your Conntact"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  hintText: "email",
                  onchanged: (data) {
                    setState(() {
                      email = data;
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  hintText: "ContactName",
                  onchanged: (data) {
                    setState(() {
                      name = data;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  print("eee====$email");
                  if (await cheackIfExist(email!)) {
                    setState(() {
                      conntact.add(ContactModel(name: name, email: email));
                    });
                    SupabaseServices().addContact(
                      currentUesrId: supabase.auth.currentUser!.id,
                      contactUserId: contact_id,
                      name: name!,
                    );
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('The User dont have acount')),
                    );
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }
}
