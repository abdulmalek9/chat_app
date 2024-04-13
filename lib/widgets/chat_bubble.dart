import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/profile_model.dart';
import 'package:chat_app/supabase/supabase_class.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.message,
    // required this.profile,
  });
  final Message message;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final Map<String, Profile> _profileCache = {};
  Profile? profile;
  Future<void> _loadProfileCache(String profileId) async {
    if (_profileCache[profileId] != null) {
      return;
    }
    final data = await SupabaseServices()
        .supabase
        .from('profiles')
        .select()
        .eq('id', profileId)
        .single();
    final profileFromMap = Profile.fromMap(data);

    if (!mounted) return;
    setState(() {
      _profileCache[profileId] = profileFromMap;
      profile = _profileCache[widget.message.profileId];
    });
  }

  @override
  void initState() {
    _loadProfileCache(widget.message.profileId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!widget.message.isMine)
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
            color: widget.message.isMine
                ? Theme.of(context).primaryColor
                : Colors.purple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(widget.message.content),
        ),
      ),
      const SizedBox(width: 12),
      // Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (widget.message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      child: Row(
        mainAxisAlignment: widget.message.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
