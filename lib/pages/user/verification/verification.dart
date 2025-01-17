import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:tcwdapp/components/text_border_field.dart';
import 'package:tcwdapp/pages/connection.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;
  final dio = Dio();
  final String ip = Connection.ip;

  final usernameText = TextEditingController();
  final verificationCodeText = TextEditingController();

  void submit() async {
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
        final response = await dio.post('$ip/api/verify-user',
            data: {
              'username': usernameText.text,
              'verification_code': verificationCodeText.text,
            },
            options: Options(headers: {
              'Content-Type': 'application/json', // Add Content-Type header
              'Accept': 'application/json', // Add any custom header
            }));

        if (!context.mounted) return;

        if (response.data['status']) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('SAVED!'),
                content: Text(response.data['message']),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok"))
                ],
              );
            },
          );
        }

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Verification"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'ACCOUNT VERIFICATION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextBorderField(
                      controller: usernameText,
                      label: "Username",
                      validate: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextBorderField(
                      controller: verificationCodeText,
                      label: "Verification Code",
                      validate: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      elevation: 0,
                      backgroundColor: Colors.cyan[600],
                    ),
                    onPressed: () {
                      submit();
                    },
                    label: const Text(
                      'VERIFY',
                      style: TextStyle(color: Colors.white),
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
                            Icons.pin_invoke,
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
