import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/user/dashboard/components/list_of_bill.dart';

import '../../connection.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final searchTextController = TextEditingController();
  late Future<List<dynamic>> _future;
  final dio = Dio();
  String ip = Connection.ip;
  late SharedPreferences _pref;
  late Map<String, dynamic> user;
  late String userAccount;
  late String name = '';
  late String meterNo = '';
  late String totalBalance = "0";
  var formatter = NumberFormat('#,##,000');

  void loadUser() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    setState(() {
      user = jsonDecode(userAccount)["user"];
      name = user['lname'] + ', ' + user['fname'] + ' ' + user['mname'];
      meterNo = user['meter_no'];
    });

    loadBalance(user);
  }

  void loadBalance(dynamic myUser) async {
    dynamic response = await dio.get('$ip/api/user-bill-sum/${myUser["id"]}');

    setState(() {
      totalBalance = formatter.format(response.data['total_pendings']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.cyan,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Meter No.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  meterNo,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Name',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Current Balance',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  totalBalance,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            "BILLINGS",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(
          child: ListOfBill(),
        )
      ],
    );
  }
}
