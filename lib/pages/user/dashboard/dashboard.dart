import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/user/dashboard/components/list_of_bills.dart';
import 'package:tcwdapp/pages/user/dashboard/components/user_meter_dropdown.dart';

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
  String? name = '';
  String? meterNo = '0';
  String? userId;
  String? totalBalance = "0";
  var formatter = NumberFormat('#,###');

  void loadUser() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    setState(() {
      user = jsonDecode(userAccount)["user"];
      //print(user['mname'] != null ? 'not null sia' : 'null sia');

      name =
          "${user['lname'].toString().toUpperCase()},  ${user['fname'].toString().toUpperCase()} ${(user['mname'] != null ? user['mname'].toString().toUpperCase() : '')}";

      userId = user['id'].toString();

      //print(user);
    });
  }

  void loadBalance(String mNo) async {
    //print('$ip/api/get-meter-balance/$mNo');
    dynamic response = await dio.get('$ip/api/get-meter-balance/$mNo');
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
            padding: const EdgeInsets.fromLTRB(30, 0, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
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
                  '₱ ${totalBalance == '0' ? '0.00' : totalBalance}',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: userId != null
              ? UserMeterDropdown(
                  label: "METER NO.",
                  hint: "Select Meter No.",
                  userId: userId ?? '',
                  onChangeValue: (mNo) {
                    setState(() {
                      meterNo = mNo;
                      loadBalance(mNo);
                    });
                  })
              : const Text('...'),
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
        Expanded(
          child: ListOfBills(
            meterNo: meterNo,
          ),
        )
      ],
    );
  }
}
