import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/components/brgy_dropdown.dart';
import 'package:tcwdapp/components/city_dropdown.dart';
import 'package:tcwdapp/components/password_field.dart';
import 'package:tcwdapp/components/province_dropdown.dart';
import 'package:tcwdapp/components/re_type_password.dart';
import 'package:tcwdapp/components/text_border_field.dart';
import 'package:tcwdapp/pages/connection.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;
  final dio = Dio();
  final String ip = Connection.ip;

  String? provinceId; //for province
  String? cityId;
  String? brgyId;

  final usernameText = TextEditingController();
  final passwordText = TextEditingController();
  final retypePasswordText = TextEditingController();
  final lnameText = TextEditingController();
  final fnameText = TextEditingController();
  final mnameText = TextEditingController();
  final suffixText = TextEditingController();
  final emailText = TextEditingController();
  final contactNoText = TextEditingController();
  final streetText = TextEditingController();

  void submit() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Submitting...'),
        backgroundColor: Colors.green.shade300,
      ));

      try {
        setState(() {
          loading = false;
        });

        print(ip);
        //request
        final response = await dio.post('$ip/api/register',
            data: {
              'username': usernameText.text,
              'password': passwordText.text,
              'password_confirmation': retypePasswordText.text,
              'lname': lnameText.text,
              'fname': fnameText.text,
              'mname': mnameText.text,
              'suffix': suffixText.text,
              'email': emailText.text,
              'contact_no': contactNoText.text,
              'province': provinceId,
              'city': cityId,
              'barangay': brgyId,
              'street': streetText.text
            },
            options: Options(headers: {
              'Content-Type': 'application/json', // Add Content-Type header
              'Accept': 'application/json', // Add any custom header
            }));

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

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

  void onProvinceSelected(id) {
    setState(() {
      provinceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'ACCOUNT INFORMATION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextBorderField(
                        controller: usernameText,
                        label: "Username",
                        validate: true)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: PasswordField(
                    controller: passwordText,
                    label: "Password",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ReTypePassword(
                    controller: retypePasswordText,
                    label: "Re-type Password",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'PERSONAL INFORMATION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextBorderField(
                      controller: lnameText,
                      label: "Last Name",
                      validate: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextBorderField(
                      controller: fnameText,
                      label: "First Name",
                      validate: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextBorderField(
                      controller: mnameText,
                      label: "Middle Name",
                      validate: false),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextBorderField(
                      controller: suffixText, label: "Suffix", validate: false),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextBorderField(
                      controller: emailText, label: "Email", validate: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextBorderField(
                      controller: contactNoText,
                      label: "Contact No.",
                      validate: true),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ADDRESS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: ProvinceDropdown(
                      controller: null,
                      label: 'Province',
                      hint: 'Select Province',
                      onValueChanged: onProvinceSelected),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: CityDropDown(
                    controller: null,
                    label: 'City',
                    hint: 'Select City',
                    provinceId: provinceId ?? '',
                    onChangeValue: (id) {
                      setState(() {
                        cityId = id;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: BrgyDropDown(
                    controller: null,
                    label: 'Barangay',
                    hint: 'Select Barangay',
                    cityId: cityId ?? '',
                    onChangeValue: (id) {
                      setState(() {
                        brgyId = id;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextBorderField(
                      controller: streetText, label: "Street", validate: true),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                      'REGISTER',
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
                            Icons.account_box,
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
