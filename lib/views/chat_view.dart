import 'dart:developer';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/supabase/supabase_class.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  final String chatViewId = "chat_view";
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  late Stream<List<Message>> messagesStream;
  // = Stream.value([
  //   Message(
  //       id: "4",
  //       profileId: "profileId",
  //       content: "",
  //       createdAt: DateTime.now(),
  //       isMine: true)
  // ]);
  // late final dynamic messagesStream;
  // final Map<String, Profile> _profileCache = {};
  final SupabaseClient supabase = Supabase.instance.client;
  String? textMessage;
  late String myUserId;
  late String contactId;
  var chatId;
  TextEditingController? controller = TextEditingController();
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // other initialization code here
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    myUserId = supabase.auth.currentUser!.id;
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is String) {
      if (!mounted) return;
      setState(() {
        contactId = routeArgs;
      });
      log("contactId = = = = = $contactId");
      var id = await SupabaseServices().getChatRoomId(contactId, myUserId);
      if (id != 'not found') {
        log("chat = = = = = $id");
        setState(() {
          chatId = id;
        });
      } else {
        return;
      }

      // messagesStream = await supabase
      //     .from('messages')
      //     .select('content,contact!inner(*)')
      //     .match({'profile_id': myUserId, 'receiver_id': contactId});

      messagesStream = supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('chat_id', chatId)
          .order('created_at')
          .map((maps) => maps
              .map((map) => Message.fromMap(map: map, myUserId: myUserId))
              .toList());
      setState(() {});
      log("message ===== $messagesStream");
      isEmpty = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  // @override
  // void initState() {
  //   final myUserId = supabase.auth.currentUser!.id;
  //   final contactId = ModalRoute.of(context)!.settings.arguments as String;
  //   _messagesStream = supabase
  //       .from('messages')
  //       .stream(primaryKey: ['id'])
  //       .order('created_at')
  //       .where((maps) {
  //         for (final map in maps) {
  //           final senderId = map['sender_id'];
  //           final receiverId = map['receiver_id'];
  //           if ((senderId == myUserId && receiverId == contactId) ||
  //               (senderId == contactId && receiverId == myUserId)) {
  //             return true;
  //           }
  //         }
  //         return false;
  //       })
  //       .map((maps) => maps
  //           .map((map) => Message.fromMap(map: map, myUserId: myUserId))
  //           .toList());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isEmpty == true
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: messagesStream,
              builder: (context, snapshot) {
                // if (!(!snapshot.hasData || snapshot.data!.isEmpty)) {
                final messages = (!snapshot.hasData || snapshot.data!.isEmpty)
                    ? []
                    : snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: messages.isEmpty
                          ? const Center(
                              child: Text('Start your conversation now :)'),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                return ChatBubble(
                                  message: message,
                                );
                              },
                            ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InputField(
                      controller: controller,
                      onChanged: (message) {
                        setState(() {
                          textMessage = message;
                        });
                      },
                      onPressed: () async {
                        controller!.clear();
                        await SupabaseServices()
                            .supabase
                            .from('messages')
                            .insert([
                          {
                            'content': textMessage,
                            'profile_id': SupabaseServices()
                                .supabase
                                .auth
                                .currentUser!
                                .id,
                            'receiver_id': contactId,
                            'chat_id': chatId
                          }
                        ]);
                      },
                    ),
                  ],
                );
                // } else {
                // return const Center(child: CircularProgressIndicator());
                // }
              }),
    );
  }
}
