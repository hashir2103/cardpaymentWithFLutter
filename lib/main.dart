import 'package:cardpayment/pages/existingcard.dart';
import 'package:cardpayment/pages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home',
      routes: {
        '/home':(context)=> HomePage(),
        '/existing-cards' : (context)=> ExistingCards(),
      },
    );
  }
}
