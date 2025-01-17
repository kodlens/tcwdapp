import 'package:flutter/material.dart';
import 'package:tcwdapp/login.dart';
import 'package:tcwdapp/pages/meter_reader/components/reading_list.dart';
import 'package:tcwdapp/pages/meter_reader/meter_reading/add_edit_meter_reading.dart';
import 'package:tcwdapp/pages/meter_reader/meter_reading/meter_reading.dart';

class ReaderHomePage extends StatelessWidget {
  const ReaderHomePage({super.key});

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
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when back is pressed
        bool? shouldLogout = await showDialog(
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

        // If the user chooses to log out, allow the back action
        return shouldLogout ?? false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: meterReaderScreen(context),
      ),
    );
  }

  Widget meterReaderScreen(BuildContext context) {
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
                leading: const Icon(Icons.electric_meter,
                    color: Colors.cyan), // Icon here
                title: const Text('New Reading'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.of(context).pushNamed('/add-edit-meter-reading');
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.logout, color: Colors.cyan), // Icon here
                title: const Text('LOGOUT'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  popExit(context);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditMeterReading(),
              ),
            );
          },
          label: const Text("New"),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.5),
              ),
              minimumSize: const Size(80, 50),
              iconColor: Colors.white,
              foregroundColor: Colors.white,
              backgroundColor: Colors.cyan),
          icon: const Icon(Icons.add),
        ),
        body: const ReadingList());
  }
}
