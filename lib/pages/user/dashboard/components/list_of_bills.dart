import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcwdapp/pages/user/dashboard/user_bill.dart';

import '../../../connection.dart';
import 'package:intl/intl.dart';

class ListOfBills extends StatefulWidget {
  final String? meterNo;
  const ListOfBills({super.key, required this.meterNo});

  @override
  State<ListOfBills> createState() => _ListOfBillsState();
}

class _ListOfBillsState extends State<ListOfBills> with WidgetsBindingObserver {
  late Future<List<dynamic>> _future;
  final dio = Dio();
  String ip = Connection.ip;
  late SharedPreferences _pref;
  late dynamic user;
  late String userAccount;
  var formatter = NumberFormat('#,###');

  final double paddingLeft = 20;
  @override
  void initState() {
    // TODO: implement initState

    _future = fetchData();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<List<dynamic>> fetchData() async {
    _pref = await SharedPreferences.getInstance();
    userAccount = _pref.getString('user') ?? '{}';
    user = jsonDecode(userAccount);

    dynamic response =
        await dio.get('$ip/api/get-meter-bills/${widget.meterNo}');

    return response.data;
  }

  @override
  void didUpdateWidget(ListOfBills oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the userId has changed, and refresh data if so
    if (widget.meterNo != oldWidget.meterNo) {
      refreshData();
    }
  }

  Future<void> refreshData() async {
    // Simulate fetching new data
    //await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _future = fetchData();
    });
  }

  @override
  void dispose() {
    // Unregister the observer to avoid memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // When the app comes to the foreground, refresh the page
      refreshData();
    }
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
                child: Text('No billings are available...'),
              );
            }

            return RefreshIndicator(
              onRefresh: refreshData,
              child: ListView.builder(
                itemCount: data.length, // Number of items in the list
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 1.0, // Border width
                        style: BorderStyle
                            .solid, // Border style (solid, dashed, etc.)
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserBill(userBill: data[index]),
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
                                padding: EdgeInsets.only(
                                    left: paddingLeft, bottom: 0, top: 5),
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
                                padding: EdgeInsets.only(
                                    left: paddingLeft, bottom: 12.0),
                                child: Text(
                                  DateFormat('MMM. dd, yyyy').format(
                                    DateTime.parse(data[index]
                                            ['reading_date'] ??
                                        '1970-01-01'),
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
                                padding: EdgeInsets.only(
                                    left: paddingLeft, bottom: 0),
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
                                padding: EdgeInsets.only(
                                    left: paddingLeft, bottom: 5),
                                child: Text(
                                  DateFormat('MMM. dd, yyyy').format(
                                    DateTime.parse(
                                        data[index]['due_date'] ?? ''),
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
                              Text(
                                "TOTAL",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors
                                          .grey[600], // Lighter text for label
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text(
                                  "₱ ${formatter.format(data[index]['total'] ?? '')}",
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
