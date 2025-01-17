import 'package:flutter/material.dart';

class ReTypePassword extends StatefulWidget {
  final controller;
  final String label;

  const ReTypePassword({super.key, this.controller, required this.label});

  @override
  State<ReTypePassword> createState() => _ReTypePasswordState();
}

class _ReTypePasswordState extends State<ReTypePassword> {
  bool _showPassword = true;
  //get controller => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: widget.controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else {
              return null;
            }
          },
          obscureText: _showPassword,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() => _showPassword = !_showPassword);
              },
              child: Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
                //Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
