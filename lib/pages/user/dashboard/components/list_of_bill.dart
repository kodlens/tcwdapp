import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../connection.dart';

class ListOfBill extends StatefulWidget {
  const ListOfBill({super.key});

  @override
  State<ListOfBill> createState() => _ListOfBillState();
}

class _ListOfBillState extends State<ListOfBill> {
  late Future<List<dynamic>> _future;
  final dio = Dio();
  String ip = Connection.ip;
  late SharedPreferences _pref;
  late dynamic user;
  late String userAccount;

  @override
  void initState() {
    // TODO: implement initState

    _future = fetchData();
    super.initState();
  }

  Future<List<dynamic>> fetchData() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    user = jsonDecode(userAccount);
    String userId = user['user']['id'];

    dynamic response = await dio.get('$ip/user-bills/$userId');

    print(response);

    return response;
  }

  Widget cardTemplate(data) {
    return const InkWell(
      child: Card(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Text('Smaple card template information')),
            SizedBox(
              height: 1.5,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
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
            final lists = snapshot.data!;
            return const Card(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Text('Sample'),
                  ),
                ],
              ),
            );
          }
        });
  }
}
