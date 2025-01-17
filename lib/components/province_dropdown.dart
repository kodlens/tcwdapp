import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/classes/combox.dart';
import 'package:tcwdapp/pages/connection.dart';

class ProvinceDropdown extends StatefulWidget {
  final controller;
  final String label;
  final String hint;

  const ProvinceDropdown(
      {super.key,
      this.controller,
      required this.label,
      required this.hint,
      required this.onValueChanged});
  final Function(String?)
      onValueChanged; // Callback to notify parent about value change

  @override
  State<ProvinceDropdown> createState() => _ProvinceDropdownState();
}

List<ComboBoxItem> list = <ComboBoxItem>[];

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  final dio = Dio();
  String ip = Connection.ip;
  late Future<List<dynamic>> _future;
  String? selectedProvinceId;

  Future<List<dynamic>> fetchData() async {
    dynamic res = await dio.get('$ip/api/provinces');
    return res.data;
  }

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  void refreshData() {
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
            //print(data);
            // return Center(
            //   child: Text(data[0].toString()),
            // );

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
                            value: selectedProvinceId,
                            items: data.map((dynamic item) {
                              return DropdownMenuItem<String>(
                                  value: item['province_id'].toString(),
                                  child:
                                      Text(item['province_name'].toString()));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                //list = value;
                                selectedProvinceId = value!;
                                widget.onValueChanged(value);
                              });
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
