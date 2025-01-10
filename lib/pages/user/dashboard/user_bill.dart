import 'package:flutter/material.dart';

class UserBill extends StatefulWidget {
  final dynamic userBill;

  const UserBill({super.key, this.userBill});

  @override
  State<UserBill> createState() => _UserBillState();
}

class _UserBillState extends State<UserBill> {
  @override
  Widget build(BuildContext context) {
    print(widget.userBill['original_bill']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Information"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "READING DATE",
            ),
            Text(
              widget.userBill["reading_date"].toString(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("DUE DATE"),
            Text(widget.userBill['due_date']),
            const Text("PREVIOUS READING"),
            Text(widget.userBill['prev_readings'].toString()),
            const Text("CURRENT READING"),
            Text(widget.userBill['current_readings'].toString()),
            const Text("OVER DUE"),
            Text(widget.userBill['is_overdue'] == 1 ? 'YES' : 'NO'),
            const Text("OTHER FEE"),
            Text(widget.userBill['add_fees_sum'].toString()),
            const Text("FEE"),
            Text(widget.userBill['original_bill'].toString()),
            const Text("TOTAL FEE"),
            Text(widget.userBill['total'].toString())
          ],
        ),
      ),
    );
  }
}
