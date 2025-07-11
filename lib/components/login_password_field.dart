import 'package:flutter/material.dart';

class LoginPasswordField extends StatefulWidget {
  final controller;

  const LoginPasswordField({super.key, this.controller});

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        filled: true, // Set this to true
        fillColor: Colors.white, // Set the background color
        prefixIcon: const Icon(Icons.password),
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
    );
  }
}
