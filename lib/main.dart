import 'package:flutter/material.dart';
import 'package:tcwdapp/login.dart';
import 'package:tcwdapp/pages/homepage.dart';
import 'package:tcwdapp/pages/meter_reader/reader_homepage.dart';

void main() {
  runApp(const StartPage());
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      title: 'TCWD',
      home: const Login(),
      routes: {
        //'/': (context) => HomePage(),
        //register the routes here...
        '/homepage': (context) => const HomePage(),
        '/reader_homepage': (context) => const ReaderHomePage(),
        // '/my-account': (context) => const MyAccount(),
      },
    );
  }
}
