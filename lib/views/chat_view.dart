import 'dart:developer';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/profile_model.dart';
import 'package:chat_app/supabase/supabase_class.dart';
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
  final Map<String, Profile> _profileCache = {};
  final SupabaseClient supabase = Supabase.instance.client;
  String? textMessage;
  late String myUserId;
  late String contactId;
  var chatId;
  TextEditingController? controller;

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

  Future<void> _loadProfileCache(String profileId) async {
    if (_profileCache[profileId] != null) {
      return;
    }
    final data =
        await supabase.from('profiles').select().eq('id', profileId).single();
    final profile = Profile.fromMap(data);
    if (!mounted) return;
    setState(() {
      _profileCache[profileId] = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
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

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂
                            _loadProfileCache(message.profileId);

                            return ChatBubble(
                              message: message,
                              profile: _profileCache[message.profileId],
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
                      // controller!.clear();
                    });
                  },
                  onPressed: () async {
                    await SupabaseServices().supabase.from('messages').insert([
                      {
                        'content': textMessage,
                        'profile_id':
                            SupabaseServices().supabase.auth.currentUser!.id,
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

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.profile,
  });

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null
              ? const SizedBox()
              : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color:
                message.isMine ? Theme.of(context).primaryColor : Colors.purple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      // Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
