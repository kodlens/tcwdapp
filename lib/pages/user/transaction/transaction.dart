import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/connection.dart';

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
    return Column(
      children: [
        FutureBuilder(
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
              final data = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Billing date
                                    // Billing Date
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 0, top: 5),
                                      child: Text(
                                        "Type",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: Colors.grey[
                                                  600], // Lighter text for label
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, bottom: 12.0),
                                      child: Text(
                                        "${data[index]['type']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors
                                                  .black87, // Dark text for data
                                            ),
                                      ),
                                    ),

                                    //DUE DATE
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 0),
                                      child: Text(
                                        "TRANSACTION DATE",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: Colors.grey[
                                                  600], // Lighter text for label
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, bottom: 5),
                                      child: Text(
                                        // DateFormat('MMM. dd, yyyy').format(
                                        //   DateTime.parse(item['billing_date']),
                                        // ),
                                        "${data[index]['created_at']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors
                                                  .black87, // Dark text for data
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 0),
                                  child: Text(
                                    "PAYMENT:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.grey[
                                              600], // Lighter text for label
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, bottom: 0),
                                  child: Text(
                                    formatter.format(data[index]['amount']),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors
                                              .black87, // Dark text for data
                                        ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        )
      ],
    );
  }
}
