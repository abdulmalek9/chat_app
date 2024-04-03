import 'dart:developer';

import 'package:chat_app/models/contact_model.dart';
import 'package:chat_app/supabase/supabase_class.dart';
import 'package:chat_app/views/chat_view.dart';
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
  List<Map<String, dynamic>> info = [];
  List<ContactModel> conntact = [];
  bool isLoading = true;

  initContact() async {
    List<Map<String, dynamic>> initContact =
        await SupabaseServices().getContact();
    log("init contact is = = = = = = $initContact");
    if (initContact.isEmpty) {
      return [];
    } else {
      return initContact;
    }
  }

  @override
  void initState() {
    if (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        info = await initContact();
        if (info.isEmpty) {
          print("object Hello Worlld ");

          return;
        } else {
          log("coco == = = = = ${info[0]['email']}");
          for (int i = 0; i < info.length; i++) {
            setState(() {
              conntact.add(ContactModel(
                  name: info[i]["contactName"],
                  email: info[i]["email"],
                  contactId: info[i]['contactUserId']));
            });
          }
          isLoading = false;
        }
      });
    }
    isLoading = false;
    log("inof is = = = = = = = $info");

    super.initState();
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
              padding: const EdgeInsets.symmetric(horizontal: 18),
              onPressed: () async {
                await supabase.auth.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, 'signin_view');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: isLoading == true
          ? conntact.isEmpty
              ? const SizedBox()
              : const Center(
                  child: CircularProgressIndicator(),
                )
          : ListView.builder(
              itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, const ChatView().chatViewId,
                      arguments: conntact[i].contactId);
                },
                child: ContactWidget(
                  image: "assets/majed.jpg",
                  name: conntact[i].name!,
                  lastmessage: "Hello, Do you wanna build a snow man?",
                ),
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
                  if (email != supabase.auth.currentUser!.email) {
                    bool isadded = cheackIfAdded(email: email!);
                    if (await SupabaseServices().cheackIfExist(email!) &&
                        !isadded) {
                      dynamic id = await SupabaseServices().selectFromTable(
                          tableName: "profiles",
                          rowName: 'id',
                          filterColumn: 'email',
                          filterValue: email);
                      print("==== = = == =  = ${id[0]['id']}");
                      SupabaseServices().addContact(
                        currentUesrId: supabase.auth.currentUser!.id,
                        contactUserId: id[0]['id'],
                        name: name!,
                        email: email!,
                      );
                      var d = SupabaseServices().addChatRoom(
                          memb1: supabase.auth.currentUser!.id,
                          memb2: id[0]['id']);
                      print('d = = = = $d ');

                      setState(() {
                        conntact.add(ContactModel(
                            name: name, email: email, contactId: id[0]['id']));
                      });
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: isadded == true
                                ? const Text('The User is already exsit')
                                : const Text('The User dont have acount')),
                      );
                    }
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('This email is for this account')),
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

  bool cheackIfAdded({required String email}) {
    for (int i = 0; i < conntact.length; i++) {
      if (conntact[i].email == email) {
        return true;
      }
    }
    return false;
  }
}
