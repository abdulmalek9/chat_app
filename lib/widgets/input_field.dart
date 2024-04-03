import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key, this.onChanged, this.onPressed, this.controller});
  final Function(String)? onChanged;
  final void Function()? onPressed;
  final TextEditingController? controller;
  // final
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 12),
          child: Container(
            padding: const EdgeInsets.only(left: 8.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24))),
            width: MediaQuery.of(context).size.width * 0.80,
            child: TextField(
              controller: controller,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Type a message ...',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return Theme.of(context)
                      .primaryColor; // Use the component's default.
                },
              ),
            ),
            icon: const Icon(
              Icons.send,
              size: 30,
            ),
            onPressed: onPressed),
      ],
    );
  }
}
