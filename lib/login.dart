import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tcwdapp/components/password_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:tcwdapp/pages/connection.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // void loginSubmit() {
  //   print("Button click from login");
  //
  //
  //   Navigator.of(context).pushReplacementNamed('/homepage');
  //
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late SharedPreferences _pref;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final dio = Dio();

  final ip = Connection.ip;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPreferences();
  }

  void _initPreferences() async {
    _pref = await SharedPreferences.getInstance();
  }

  // Save a string value to shared preferences
  _saveToSharedPreferences(String value) async {
    //save response (user information)
    await _pref.setString('user', value);

    final user = jsonDecode(value);

    final String role = user['user']['role'].toLowerCase();
    if (context.mounted) {
      if (role == 'user') {
        Navigator.of(context).pushReplacementNamed('/homepage');
      }

      if (role == 'reader') {
        Navigator.of(context).pushReplacementNamed('/reader_homepage');
      }
    }
  }

  void loginSubmit() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Authenticating...'),
        backgroundColor: Colors.green.shade300,
      ));

      try {
        setState(() {
          _isLoading = true;
        });

        //request
        final response = await dio.post(
          '$ip/api/login',
          data: {
            'username': usernameController.text,
            'password': passwordController.text
          },
        );

        print(response);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        passwordController.text = '';
        usernameController.text = '';

        await _saveToSharedPreferences(response.toString());
      } on DioException catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        //final String errMsg = '';

        if (e.response != null) {
          final errMsg = e.response!.data['logs'].toString();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(errMsg),
              backgroundColor: Colors.red.shade300,
            ));
          }
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message.toString()),
              backgroundColor: Colors.red.shade300,
            ));
          }
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('paulit2');

    return Scaffold(
      body: Form(
          key: _formKey,
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
                      controller: usernameController,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PasswordField(controller: passwordController),
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
                      label: _isLoading ? const Text('') : const Text('LOGIN'),
                      icon: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            )
                          : const Icon(Icons.login),
                    ),
                  )
                ],
              ),
            ),
          ))),
    );
  }
}
