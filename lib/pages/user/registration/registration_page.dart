import 'package:flutter/material.dart';
import 'package:tcwdapp/components/password_field.dart';
import 'package:tcwdapp/components/re_type_password.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              controller: null,
            ),
          ),
          const SizedBox(height: 20),
          const PasswordField(controller: null),
          const SizedBox(height: 20),
          const ReTypePassword(
            controller: null,
            label: "Re-type Password",
          ),
        ],
      ),
    );
  }
}
