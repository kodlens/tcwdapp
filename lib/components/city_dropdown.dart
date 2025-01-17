import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/classes/combox.dart';
import 'package:tcwdapp/pages/connection.dart';

class CityDropDown extends StatefulWidget {
  final controller;
  final String label;
  final String hint;
  final String? provinceId;
  final Function onChangeValue;

  const CityDropDown(
      {super.key,
      this.controller,
      required this.label,
      required this.hint,
      required this.provinceId,
      required this.onChangeValue});

  @override
  State<CityDropDown> createState() => _CityDropDownState();
}

class _CityDropDownState extends State<CityDropDown> {
  final dio = Dio();
  String ip = Connection.ip;
  Future<List<dynamic>>? _future;
  String? selectedId;

  List<ComboBoxItem>? cmbList = [];

  Future<List<dynamic>> fetchData() async {
    dynamic res = await dio.get('$ip/api/cities/${widget.provinceId}');
    print(res.data);
    return res.data;
  }
  // void fetchData() async {
  //   dynamic res = await dio.get('$ip/api/cities/${widget.provinceId}');

  //    res.data;
  // }

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    // cmbList!.add(ComboBoxItem(itemValue: '1', itemLabel: 'Value 1'));
    //cmbList!.add(ComboBoxItem(itemValue: '2', itemLabel: 'Value 2'));
  }

  @override
  void didUpdateWidget(CityDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the provinceId has changed, and refresh data if so
    if (widget.provinceId != oldWidget.provinceId) {
      refreshData();
      setState(() {
        selectedId = null;
      });
    }
  }

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
            return const Center(
              child: Text('Select Province first.'),
            );
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
                            border: Border.all(
                                color: Colors.black45), // Border color
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
                                value: item['municipality_id'].toString(),
                                child: Text(item['municipality_name']),
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
