import 'package:flutter/material.dart';
import 'package:tcwdapp/pages/user/concern/concern.dart';
import 'package:tcwdapp/pages/user/dashboard/dashboard.dart';
import 'package:tcwdapp/pages/profile/profile.dart';
import 'package:tcwdapp/pages/user/transaction/transaction.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Transaction(),
    Concern(),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TCWD System',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.support_agent),
          //   label: 'Concerns',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_2),
          //   label: 'Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
