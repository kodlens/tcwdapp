import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tcwdapp/classes/user.dart';
import 'package:tcwdapp/pages/meter_reader/meter_reading/consumer_list.dart';

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
  User? selectedUser; // This will store the selected user
  bool _isLoading = false;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await dio.post(
        '$ip/api/store-meter-billing',
        data: {
          'meter_no': selectedUser?.meterNo,
          'readings': consumerCurrentReading.text,
          'reading_date': consumerDateReading.text
        },
      );

      if (context.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          if (response.data['status'] == 'Success') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('SAVED!'),
                  content: const Text('Reading successfully saved.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            consumerCurrentReading.text = "";
                            consumerDateReading.text = "";
                            consumerNameController.text = "";
                            selectedUser = null;
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok"))
                  ],
                );
              },
            );
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
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
                            // openModal(context);
                            //Navigator.of(context).pushNamed('/consumer-list');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ConsumerList(onUserSelected: (user) {
                                  // When a user is selected, update the state of the parent scaffold
                                  setState(() {
                                    selectedUser = user;
                                    consumerNameController.text =
                                        '${user.fname} ${user.lname}';
                                  });
                                  Navigator.pop(
                                      context); // Go back to the parent scaffold
                                }),
                              ),
                            );
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select date.';
                        }
                        return null;
                      },
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
                      icon: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            )
                          : const Icon(Icons.save),
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
