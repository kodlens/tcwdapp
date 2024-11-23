import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Card(
          color: Colors.cyan,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Current Balance',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '2,500.00',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
