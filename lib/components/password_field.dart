import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final dynamic controller;
  final String? label;

  const PasswordField({super.key, this.controller, this.label});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = true;
  //get controller => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label!,
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
            labelText: "Password",
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
