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
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyBottomNavigationBar(),
      ),
    );
  }
}
