import 'package:flutter/material.dart';
import 'package:stripe_pay_app/screens/address_verification_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AccountVerificationScreen(),
    );
  }
}




