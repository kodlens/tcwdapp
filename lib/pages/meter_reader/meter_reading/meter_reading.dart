import 'package:flutter/material.dart';
import 'package:tcwdapp/pages/meter_reader/meter_reading/add_edit_meter_reading.dart';

class MeterReading extends StatelessWidget {
  const MeterReading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meter Reading"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("Sample"),
          ),
          Container(
            child: Text("Second Sample"),
          )
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditMeterReading(),
            ),
          );
        },
        label: const Text("New"),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.5),
            ),
            minimumSize: const Size(80, 50),
            iconColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.cyan),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
