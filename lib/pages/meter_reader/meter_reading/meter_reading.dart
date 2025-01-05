import 'package:flutter/material.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text("New"),
      ),
    );
  }
}
