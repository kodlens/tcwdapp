import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/classes/combox.dart';
import 'package:tcwdapp/pages/connection.dart';

class BrgyDropDown extends StatefulWidget {
  final controller;
  final String label;
  final String hint;
  final String? cityId;
  final Function onChangeValue;

  const BrgyDropDown(
      {super.key,
      this.controller,
      required this.label,
      required this.hint,
      required this.cityId,
      required this.onChangeValue});

  @override
  State<BrgyDropDown> createState() => _BrgyDropDownState();
}

class _BrgyDropDownState extends State<BrgyDropDown> {
  final dio = Dio();
  String ip = Connection.ip;
  Future<List<dynamic>>? _future;
  String? selectedId;

  Future<List<dynamic>> fetchData() async {
    dynamic res = await dio.get('$ip/api/barangays/${widget.cityId}');
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
  void didUpdateWidget(BrgyDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the provinceId has changed, and refresh data if so
    if (widget.cityId != oldWidget.cityId) {
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
              child: Text('Select City first.'),
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
                                value: item['barangay_id'].toString(),
                                child: Text(item['barangay_name']),
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
  }
}
