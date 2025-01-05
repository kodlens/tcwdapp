import 'package:flutter/material.dart';

class ReaderHomePage extends StatelessWidget {
  const ReaderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meter Reader'),
          backgroundColor: Colors.cyan[600],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('MENU', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: const Icon(Icons.gas_meter,
                    color: Colors.cyan), // Icon here
                title: const Text('Meter Reading'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.of(context).pushNamed('/meter-reading');
                },
              ),
              ListTile(
                leading: const Icon(Icons.electric_meter,
                    color: Colors.cyan), // Icon here
                title: const Text('New Reading'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.of(context).pushNamed('/add-edit-meter-reading');
                },
              ),
            ],
          ),
        ));
  }
}
