import 'package:flutter/material.dart';

class TextBorderField extends StatefulWidget {
  final controller;
  final String label;
  final bool validate;

  const TextBorderField(
      {super.key,
      this.controller,
      required this.label,
      required this.validate});

  @override
  State<TextBorderField> createState() => _TextBorderFieldState();
}

class _TextBorderFieldState extends State<TextBorderField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (widget.validate) {
              if (value == null || value.isEmpty) {
                return 'Please enter your ${widget.label}';
              }
              return null;
            } else {
              return null;
            }
          },
          controller: widget.controller,
        ),
      ],
    );
  }
}
