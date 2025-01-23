import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcwdapp/pages/connection.dart';
import 'package:tcwdapp/pages/theme_style.dart';

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
  final String ip = Connection.ip;
  final dio = Dio();
  var formatter = NumberFormat('#,###');

  void pay() async {
    setState(() {
      loading = true;
    });

    try {
      final String name = widget.userBill['lname'] +
          ', ' +
          widget.userBill['fname'] +
          ' ' +
          (widget.userBill['mname'] ?? '');
      Map<String, dynamic> paymentData = {
        'data': {
          'attributes': {
            'billing': {
              'email': widget.userBill['email'],
              'name': name,
              'phone': widget.userBill['contact_no'],
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
            'success_url': '$ip/api/payment/success',
            'cancel_url': '$ip/view-user-bill/2',
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
              returnUrl: '',
            ),
          ),
        );

        if (res) {
          final successResponse =
              await dio.post('$ip/api/payment/success/mobile',
                  data: {
                    'billing_id': widget.userBill['id'],
                    'amount': widget.userBill['total'],
                    'user_id': widget.userBill['user_id']
                  },
                  options: Options(
                      headers: {'Accept': 'application/json'},
                      followRedirects: false,
                      validateStatus: (status) {
                        return status! < 500;
                      }));

          //print(successResponse.data);
          if (successResponse.data['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                  'Payment successfull. You may go back to Bill page.'),
              backgroundColor: Colors.green.shade300,
            ));
          }
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Bill Information"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.blue, // Border color
                width: 1.0, // Border width
                style: BorderStyle.solid, // Border style (solid, dashed, etc.)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OVER DUE",
                    style: ThemeStyle.labelStyle,
                  ),
                  Text(
                    widget.userBill['is_overdue'] == 1 ? 'YES' : 'NO',
                    style: ThemeStyle.outputStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /* ====================================================== */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "READING DATE",
                            style: ThemeStyle.labelStyle,
                          ),
                          Text(
                              DateFormat('MMM. dd, yyyy').format(DateTime.parse(
                                  widget.userBill['reading_date'])),
                              style: ThemeStyle.outputStyle),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "PREVIOUS READING",
                            style: ThemeStyle.labelStyle,
                          ),
                          Text(
                            widget.userBill['prev_readings'].toString(),
                            style: ThemeStyle.outputStyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DUE DATE",
                            style: ThemeStyle.labelStyle,
                          ),
                          Text(
                            DateFormat('MMM. dd, yyyy').format(
                                DateTime.parse(widget.userBill['due_date'])),
                            style: ThemeStyle.outputStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "CURRENT READING",
                            style: ThemeStyle.labelStyle,
                          ),
                          Text(
                            widget.userBill['current_readings'].toString(),
                            style: ThemeStyle.outputStyle,
                          ),
                        ],
                      )
                    ],
                  ),

                  /* ====================================================== */

                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "OTHER FEE",
                    style: ThemeStyle.labelStyle,
                  ),
                  Text(
                    "₱ ${formatter.format(widget.userBill['total_add_fees'])}",
                    style: ThemeStyle.outputStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              widget.userBill['additional_fees_details'].length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userBill['additional_fees_details']
                                      [index]['title'],
                                  style: ThemeStyle.labelStyle,
                                ),
                                Text(
                                  "₱ ${formatter.format(widget.userBill['additional_fees_details'][index]['amount'])}",
                                  style: ThemeStyle.smallOutputStyle,
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "FEE",
                    style: ThemeStyle.labelStyle,
                  ),
                  Text(
                    "₱ ${widget.userBill['original_bill'].toString()}",
                    style: ThemeStyle.outputStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("TOTAL FEE", style: ThemeStyle.labelStyle),
                  Text("₱ ${formatter.format(widget.userBill['total'])}",
                      style: ThemeStyle.outputStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    label: const Text(
                      "PAY (₱)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      pay();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      iconColor: Colors.white,
                      foregroundColor: Colors.white,
                      backgroundColor: ThemeStyle.blueColor,
                    ),
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
      ),
    );
  }
}
