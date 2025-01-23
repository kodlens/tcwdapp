import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/classes/user.dart';
import 'package:tcwdapp/pages/connection.dart';
import 'package:tcwdapp/pages/theme_style.dart';

class ConsumerList extends StatefulWidget {
  final Function(User) onUserSelected;

  const ConsumerList({super.key, required this.onUserSelected});

  @override
  State<ConsumerList> createState() => _ConsumerListState();
}

class _ConsumerListState extends State<ConsumerList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String ip = Connection.ip;
  final dio = Dio();
  late Future<List<dynamic>> _future;
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _future = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    dynamic response = await dio
        .get('$ip/api/search-users-lname?lname=${searchTextController.text}');
    return response.data;
  }

  void refreshData() async {
    setState(() {
      _future = fetchData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Consumers"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchTextController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Search Name/Meter no..."),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
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
                        backgroundColor: ThemeStyle.blueColor),
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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
                        child: ListView(
                          children: data
                              .map(
                                (item) => Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'NAME',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(item['lname'] +
                                                ', ' +
                                                item['fname']),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'METER NO',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(item['meter_no']),
                                          ],
                                        )),
                                    onTap: () {
                                      widget.onUserSelected(User(
                                          fname: item['fname'].toString(),
                                          lname: item['lname'].toString(),
                                          mname: item['mname'].toString(),
                                          id: item['id'].toString(),
                                          meterNo: item['meter_no']));
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
