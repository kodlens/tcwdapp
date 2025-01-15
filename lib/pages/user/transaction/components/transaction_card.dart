import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransctionCard extends StatefulWidget {
  const TransctionCard({super.key, required this.data, required this.index});

  final List<dynamic> data;
  final int index;

  @override
  State<TransctionCard> createState() => _TransctionCardState();
}

class _TransctionCardState extends State<TransctionCard> {
  var formatter = NumberFormat('#,##,000');

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Billing date
                    // Billing Date

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 0, top: 5),
                      child: Text(
                        "Type",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600], // Lighter text for label
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, bottom: 12.0),
                      child: Text(
                        "${widget.data[widget.index]['type']}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87, // Dark text for data
                            ),
                      ),
                    ),

                    //DUE DATE
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 0),
                      child: Text(
                        "TRANSACTION DATE",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600], // Lighter text for label
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                      child: Text(
                        // DateFormat('MMM. dd, yyyy').format(
                        //   DateTime.parse(item['billing_date']),
                        // ),
                        DateFormat('MMM. dd, yyyy hh:mm a').format(
                          DateTime.parse(widget.data[widget.index]
                                  ['created_at'] ??
                              '1970-01-01'),
                        ),

                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87, // Dark text for data
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 0),
                  child: Text(
                    "PAYMENT:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600], // Lighter text for label
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 0),
                  child: Text(
                    formatter.format(widget.data[widget.index]['amount']),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87, // Dark text for data
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
