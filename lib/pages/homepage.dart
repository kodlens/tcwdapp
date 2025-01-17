import 'package:flutter/material.dart';
import 'package:tcwdapp/components/bottom_navigation.dart';
import 'package:tcwdapp/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when back is pressed
        bool? shouldLogout = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Are you sure you want to logout?')
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false); // Don't log out, just stay
                },
                child: const Text("No"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.exit_to_app), // The icon
                label: const Text("Log Out"), // The text
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false, // Removes all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // Text color
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
            ],
          ),
        );

        // If the user chooses to log out, allow the back action
        return shouldLogout ?? false;
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyBottomNavigationBar(),
      ),
    );
  }
}
