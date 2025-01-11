import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcwdapp/pages/connection.dart';

import 'package:tcwdapp/pages/user/dashboard/checkout.dart';

class UserBill extends StatefulWidget {
  final dynamic userBill;

  const UserBill({super.key, this.userBill});

  @override
  State<UserBill> createState() => _UserBillState();
}

class _UserBillState extends State<UserBill> {
  bool loading = false;
  final String paymongoKey = Connection.paymongoKey;

  final dio = Dio();

  void pay() async {
    setState(() {
      loading = true;
    });

    try {
      Map<String, dynamic> paymentData = {
        'data': {
          'attributes': {
            'billing': {
              'email': 'juan@mail.com',
              'name': 'Juan Dela Cruz',
              'phone': '9167789585',
            },
            'line_items': [
              {
                'currency': 'PHP',
                'amount': (widget.userBill['total'] * 100)
                    .toInt(), // Convert to cents
                'description': 'Payment for the bill dated',
                'name': 'Water Bill',
                'quantity': 1,
                'ID': '1234',
              },
            ],
            'metadata': {
              'billing_id': widget.userBill['id'],
              'amount': widget.userBill['total'],
              'user_id': widget.userBill['user_id'],
            },
            'payment_method_types': ['card', 'gcash'],
            'success_url': 'https://tcwd.kod-lens.tech/api/payment/success',
            'cancel_url': 'https://tcwd.kod-lens.tech/view-user-bill/2',
            'description': 'Payment for the water bill.',
            'send_email_receipt': false,
          },
        },
      };

      final response =
          await dio.post('https://api.paymongo.com/v1/checkout_sessions',
              data: paymentData,
              options: Options(headers: {
                'Authorization':
                    'Basic $paymongoKey', // Add Authorization header
                'Content-Type': 'application/json', // Add Content-Type header
                'Accept': 'application/json', // Add any custom header
              }));

      if (response.data['data']['attributes']['checkout_url']
          .toString()
          .isNotEmpty) {
        final res = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutPage(
              url: response.data['data']['attributes']['checkout_url'],
              returnUrl: 'https://tcwd.kod-lens.tech',
            ),
          ),
        );

        if (res) {
          print('HUmana');
        }
      }

      // print(response.data['data']['attributes']['checkout_url']);

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.userBill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Information"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "READING DATE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: TextEditingController(
                      text: widget.userBill['reading_date']),
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: ""),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "DUE DATE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: ""),
                  controller:
                      TextEditingController(text: widget.userBill['due_date']),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "PREVIOUS READING",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(
                      text: widget.userBill['prev_readings'].toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "CURRENT READING",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(
                      text: widget.userBill['current_readings'].toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "OVER DUE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(
                      text: widget.userBill['is_overdue'] == 1 ? 'YES' : 'NO'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "OTHER FEE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(
                      text: widget.userBill['add_fees_sum'].toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "FEE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(
                      text: widget.userBill['original_bill'].toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "TOTAL FEE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  readOnly: true,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(
                      text: widget.userBill['total'].toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  label: const Text(
                    "PAY",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    pay();
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      iconColor: Colors.white,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.cyan),
                  icon: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.payment),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
