import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:tcwdapp/pages/theme_color.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SharedPreferences _pref;

  late String userAccount = '';

  late Map<String, dynamic> user;

  Future<Map<String, dynamic>> fetchData() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    user = jsonDecode(userAccount);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final myUser = snapshot.data!['user'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /*==============PAGE TITLE=====================*/
                Container(
                  color: ThemeColor.blueColor,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(
                      'PROFILE INFORMATION',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /*==============USERNAME=====================*/
                      const SizedBox(height: 10),
                      Text(
                        'USERNAME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['username']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),

                      /*==============NAME=====================*/
                      const SizedBox(height: 10),
                      Text(
                        'NAME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['lname']} , ${myUser['fname']} ${myUser['mname'] ?? ''}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      /*=============CONTACT NO======================*/
                      const SizedBox(height: 10),
                      Text(
                        'CONTACT NO.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['contact_no']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      /*==============EMAIL=====================*/
                      const SizedBox(height: 10),
                      Text(
                        'EMAIL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['email']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      /*===============PROVINCE====================*/
                      const SizedBox(height: 10),
                      Text(
                        'PROVINCE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['province_name']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      /*===============CITY====================*/
                      const SizedBox(height: 10),
                      Text(
                        'CITY / MUNICIPALITY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['municipality_name']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      /*===============BARANGAY====================*/
                      const SizedBox(height: 10),
                      Text(
                        'BARANGAY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['barangay_name'] ?? ''}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      /*===============STREET====================*/
                      const SizedBox(height: 10),
                      Text(
                        'STREET',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "${myUser['street']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}
