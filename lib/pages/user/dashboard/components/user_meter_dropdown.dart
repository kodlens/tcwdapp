import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/classes/combox.dart';
import 'package:tcwdapp/pages/connection.dart';

class UserMeterDropdown extends StatefulWidget {
  final controller;
  final String label;
  final String hint;
  final String? userId;
  final Function onChangeValue;

  const UserMeterDropdown(
      {super.key,
      this.controller,
      required this.label,
      required this.hint,
      required this.userId,
      required this.onChangeValue});

  @override
  State<UserMeterDropdown> createState() => _UserMeterDropdownState();
}

class _UserMeterDropdownState extends State<UserMeterDropdown> {
  final dio = Dio();
  String ip = Connection.ip;
  Future<List<dynamic>>? _future;
  String? selectedId;

  Future<List<dynamic>> fetchData() async {
    dynamic res = await dio.get('$ip/api/get-user-meter/${widget.userId}');
    print(res.data);
    return res.data;
  }
  // void fetchData() async {
  //   dynamic res = await dio.get('$ip/api/cities/${widget.userId}');

  //    res.data;
  // }

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    // cmbList!.add(ComboBoxItem(itemValue: '1', itemLabel: 'Value 1'));
    //cmbList!.add(ComboBoxItem(itemValue: '2', itemLabel: 'Value 2'));
  }

  // @override
  // void didUpdateWidget(UserMeterDropdown oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // Check if the userId has changed, and refresh data if so
  //   if (widget.userId != oldWidget.userId) {
  //     refreshData();
  //     setState(() {
  //       selectedId = null;
  //     });
  //   }
  // }

  void refreshData() {
    //fetchData();
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
            return Text('No meter found. ${snapshot.error}');
          } else {
            final data = snapshot.data!;

            //print(data);
            // return Center(
            //   child: Text(data[0].toString()),
            // );
            //return (Text('dont load'));
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blue), // Border color
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                          ),
                          child: DropdownButton<String>(
                            hint: Text(widget.hint),
                            underline: Container(),
                            isExpanded: true,
                            value: selectedId,
                            items: data.map((dynamic item) {
                              return DropdownMenuItem<String>(
                                value: item['meter_no'],
                                child: Text(item['meter_no']),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              selectedId = value;
                              widget.onChangeValue(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ]);
          }
        });

    // return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   Text(
    //     widget.label,
    //     style: const TextStyle(fontWeight: FontWeight.bold),
    //   ),
    //   const SizedBox(height: 5),
    //   Row(
    //     children: [
    //       Expanded(
    //         child: Container(
    //           padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    //           decoration: BoxDecoration(
    //             border: Border.all(color: Colors.black45), // Border color
    //             borderRadius: BorderRadius.circular(5), // Rounded corners
    //           ),
    //           child: DropdownButton<String>(
    //             hint: Text(widget.hint),
    //             underline: Container(),
    //             isExpanded: true,
    //             value: selectedId,
    //             items: cmbList!.isEmpty
    //                 ? cmbList!.map((ComboBoxItem item) {
    //                     return DropdownMenuItem<String>(
    //                       value: item.itemValue,
    //                       child: Text(item.itemLabel),
    //                     );
    //                   }).toList()
    //                 : [],
    //             onChanged: (String? value) {
    //               selectedId = value;
    //               widget.onChangeValue(int.parse(value!));
    //             },
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ]);
  }
}
