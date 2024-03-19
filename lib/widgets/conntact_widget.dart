import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  const ContactWidget({
    super.key,
    required this.image,
    required this.name,
    required this.lastmessage,
  });
  final String image, name, lastmessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(
                  image,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    lastmessage,
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
