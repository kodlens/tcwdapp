import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/connection.dart';
import 'package:tcwdapp/pages/user/concern/components/concern_widget.dart';

class Concern extends StatefulWidget {
  const Concern({super.key});

  @override
  State<Concern> createState() => _ConcernState();
}

class _ConcernState extends State<Concern> {
  late SharedPreferences _pref;

  late Future<Map<String, dynamic>> user;

  late String userAccount;

  late String userId = '';
  late String ip = Connection.ip;

  Future<Map<String, dynamic>> fetchUser() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    print(jsonDecode(userAccount)["user"]);
    return jsonDecode(userAccount)["user"];
  }

  @override
  void initState() {
    // TODO: implement initState

    user = fetchUser();
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final myUser = snapshot.data!;
            return ConcernWidget(
                url: '$ip/api/mobile-user-concern/${myUser["id"]}');
          }
        });
  }
}
