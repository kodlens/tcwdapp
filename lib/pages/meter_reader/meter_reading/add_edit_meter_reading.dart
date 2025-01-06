import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../connection.dart';

class AddEditMeterReading extends StatefulWidget {
  const AddEditMeterReading({super.key});

  @override
  State<AddEditMeterReading> createState() => _AddEditMeterReadingState();
}

class _AddEditMeterReadingState extends State<AddEditMeterReading> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final consumerDateReading = TextEditingController();
  final consumerNameController = TextEditingController();
  final consumerCurrentReading = TextEditingController();
  final dio = Dio();
  String ip = Connection.ip;

  void submit() {
    if (_formKey.currentState!.validate()) {}
  }

  // Function to open the DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // Update the TextFormField with the selected date
        consumerDateReading.text =
            "${picked.toLocal()}".split(' ')[0]; // Format date as 'YYYY-MM-DD'
      });
    }
  }

  openModal(var context) async {
    dynamic response = await dio.get('$ip/api/user-bills');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            children: [
              Text("Sample"),
              Text("sample 2"),
              Text("sample 3"),
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('test');
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Reading"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ADD/EDIT METER READING",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Consumer Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input consumer name.';
                              }
                              return null;
                            },
                            controller: consumerNameController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          label: const Text(""),
                          onPressed: () {
                            openModal(context);
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
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Current Reading"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input current reading.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                      controller: consumerCurrentReading,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: consumerDateReading,
                      decoration: const InputDecoration(
                        labelText: "Select Date",
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true, // Makes the field read-only
                      onTap: () {
                        // Open the date picker when tapped
                        _selectDate(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      label: const Text("SAVE"),
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          iconColor: Colors.white,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.cyan),
                      icon: const Icon(Icons.save),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
