import 'package:flutter/material.dart';
import 'package:tcwdapp/login.dart';
import 'package:tcwdapp/pages/user/concern/concern.dart';
import 'package:tcwdapp/pages/user/dashboard/dashboard.dart';
import 'package:tcwdapp/pages/user/profile/profile.dart';
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

  void popExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Don't log out, just stay
            },
            child: const Text("Stay"),
          ),
          TextButton(
            onPressed: () {
              //Navigator.pop(context, true); // Log out and exit
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false, // This removes all previous routes
              );
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TCWD System',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                popExit(context);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        backgroundColor: const Color(0xFF12509D),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Concerns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[200],
        onTap: _onItemTapped,
        iconSize: 20,
        unselectedItemColor: Colors.white,
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        type: BottomNavigationBarType
            .fixed, // Adjust the size of the unselected label text
      ),
    );
  }
}
