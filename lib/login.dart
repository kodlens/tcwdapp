import 'package:flutter/material.dart';
import 'package:tcwdapp/components/password_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void loginSubmit() {
    print("Button click from login");
    Navigator.of(context).pushReplacementNamed('/homepage');
  }

  @override
  Widget build(BuildContext context) {
    print('paulit2');

    return Scaffold(
      body: Form(
          child: SafeArea(
              child: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(175, 218, 247, 1),
              ], // Two colors for the gradient
              begin: Alignment.topCenter, // Start from the left
              end: Alignment.bottomCenter, // End at the right
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage('assets/images/tcwd-logo.png'),
                  height: 150),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  'WELCOME TO TANGUB CITY WATER DISTRICT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Username"),
                ),
              ),
              const SizedBox(height: 20),
              const PasswordField(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.cyan[600],
                  ),
                  onPressed: () {
                    loginSubmit();
                  },
                  label: const Text("LOGIN",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ))),
    );
  }
}
