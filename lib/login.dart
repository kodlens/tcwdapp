import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tcwdapp/components/text_stroke.dart';
import 'package:tcwdapp/components/login_password_field.dart';
import 'package:tcwdapp/components/password_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:tcwdapp/pages/connection.dart';
import 'package:tcwdapp/pages/theme_color.dart';
import 'package:tcwdapp/pages/user/registration/registration_page.dart';
import 'package:tcwdapp/pages/user/verification/verification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SharedPreferences _pref;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final dio = Dio();
  final ip = Connection.ip;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPreferences();
  }

  Future<void> _dialogBuilder(
    BuildContext context,
    String dialogTitle,
    String dialogMSg,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.red,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(dialogTitle, style: const TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                Text(dialogMSg),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 233, 74, 63),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          loading = true;
        });

        //request
        final response = await dio.post(
          '$ip/api/login',
          data: {
            'username': usernameController.text,
            'password': passwordController.text
          },
        );
        setState(() {
          loading = false;
        });

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        passwordController.text = '';
        usernameController.text = '';

        await _saveToSharedPreferences(response.toString());
      } on DioException catch (e) {
        setState(() {
          loading = false;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        //final String errMsg = '';

        if (e.response != null) {
          final errMsg = e.response!.data['message'].toString();
          // if (context.mounted) {
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text(errMsg),
          //     backgroundColor: Colors.red.shade300,
          //   ));
          _dialogBuilder(context, 'Error!', errMsg);
        }
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: SafeArea(
              child: Expanded(
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/bg-login.jpg'), // Path to your background image
                    fit: BoxFit.cover,
                  ), // Ensure the image covers the entire screen
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        image: AssetImage('assets/images/tcwd-logo.png'),
                        height: 120),
                    const SizedBox(height: 1),
                    TextStroke(
                        text: "TANGUB CITY",
                        textFontSize: 30,
                        textFontWeight: FontWeight.w900,
                        textColor: const Color(0xFF12509D),
                        strokeColor: Colors.white,
                        strokeWidth: 6),
                    TextStroke(
                        text: "WATER DISTRICT",
                        textFontSize: 30,
                        textFontWeight: FontWeight.w900,
                        textColor: ThemeColor.blueColor,
                        strokeColor: Colors.white,
                        strokeWidth: 6),
                    const SizedBox(
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            filled: true, // Set this to true
                            fillColor: Colors.white, // Set the background color
                            prefixIcon: Icon(Icons.person_2_outlined),
                            border: OutlineInputBorder(),
                            labelText: "Username"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        controller: usernameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                      child: LoginPasswordField(controller: passwordController),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: const Text(
                        "Don't have account yet? Register here",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          // Adds the link-like effect
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VerificationPage()),
                        );
                      },
                      child: const Text(
                        "Verify Account",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          // Adds the link-like effect
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          elevation: 0,
                          backgroundColor: const Color(0xFF12509D),
                        ),
                        onPressed: () {
                          loginSubmit();
                        },
                        label: const Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        icon: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}
