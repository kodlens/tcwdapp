import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/connection.dart';
import 'package:tcwdapp/pages/theme_color.dart';

import 'components/transaction_card.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final searchTextController = TextEditingController();
  late Future<List<dynamic>> _future;
  final dio = Dio();
  String ip = Connection.ip;
  late SharedPreferences _pref;
  late dynamic user;
  late String userAccount;
  var formatter = NumberFormat('#,##,000');

  Future<List<dynamic>> fetchData() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    user = jsonDecode(userAccount);
    int userId = user['user']['id'];

    dynamic response =
        await dio.get('$ip/api/user-transactions?user_id=${userId}');
    return response.data;
  }

  void refreshData() async {
    setState(() {
      _future = fetchData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: ThemeColor.blueColor,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text(
                    'TRANSACTION',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TransctionCard(data: data, index: index);
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
