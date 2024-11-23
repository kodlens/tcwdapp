import 'package:flutter/material.dart';
import 'package:tcwdapp/components/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MyBottomNavigationBar());
  }
}
