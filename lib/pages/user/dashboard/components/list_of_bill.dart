import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/user/dashboard/user_bill.dart';

import '../../../connection.dart';
import 'package:intl/intl.dart';

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
  var formatter = NumberFormat('#,##,000');


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
    int userId = user['user']['id'];
    dynamic response = await dio.get('$ip/api/user-bills/$userId');
    return response.data;
  }

  Future<void> refreshData() async {
    // Simulate fetching new data
    //await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _future = fetchData();
    });
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
            final data = snapshot.data!;

            if (data.isEmpty) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: Text('No billing available...'),
              );
            }

            return Expanded(
              // Use Expanded to make ListView take remaining space
              child: ListView.builder(
                itemCount: data.length, // Number of items in the list
                itemBuilder: (context, index) {
                  return Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    child: InkWell(
                      onTap: () {
                        print(data[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserBill(userBill: data[index]),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  "BILLING DATE",
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
                                  DateFormat('MMM. dd, yyyy').format(
                                    DateTime.parse(data[index]['created_at']),
                                  ),
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
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 0),
                                child: Text(
                                  "DUE DATE",
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
                                padding:
                                    const EdgeInsets.only(left: 5.0, bottom: 5),
                                child: Text(
                                  DateFormat('MMM. dd, yyyy').format(
                                    DateTime.parse(data[index]['due_date']),
                                  ),
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

                          //balance/total container
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 0),
                                child: Text(
                                  "TOTAL",
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
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  formatter.format(data[index]['total']),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .black87, // Dark text for data
                                      ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ), // Example list item
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}
