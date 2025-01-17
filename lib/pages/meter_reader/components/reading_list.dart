import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcwdapp/pages/connection.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({super.key});

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  final searchTextController = TextEditingController();
  late Future<List<dynamic>> _future;
  final dio = Dio();
  String ip = Connection.ip;

  Future<List<dynamic>> fetchData() async {
    dynamic response =
        await dio.get('$ip/api/bills?lname=${searchTextController.text}');
    return response.data;
  }

  void refreshData() async {
    setState(() {
      _future = fetchData();
      print(_future);
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Consumer Name"),
                  controller: searchTextController,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                label: const Text(""),
                onPressed: () {
                  // openModal(context);
                  //Navigator.of(context).pushNamed('/consumer-list');
                  refreshData();
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    minimumSize: const Size(80, 50),
                    iconColor: Colors.white,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Billing date
                                      // Billing Date
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 0, top: 5),
                                        child: Text(
                                          "NAME",
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
                                          "${data[index]['lname']}, ${data[index]['fname']}",
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
                                          "READING DATE",
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
                                          "${data[index]['reading_date']}",
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Billing date
                                      // Billing Date
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 0, top: 5),
                                        child: Text(
                                          "METER NO.",
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
                                          "${data[index]['meter_no']}",
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
                                          "CURRENT READING",
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
                                          "${data[index]['current_readings']}",
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
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, bottom: 0),
                                    child: Text(
                                      "TOTAL BILL:",
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
                                      "₱ ${data[index]['original_bill']}",
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
                    }),
              );
            }
          },
        ),
      ],
    );
  }
}
