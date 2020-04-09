import 'package:flutter/material.dart';
import 'package:journalfy/route/home_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". Then, invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        primarySwatch: Colors.green, // Figure out how to change color to RGBA (107,164,16,1)
      ),
      home: HomeRoute(title: 'O Remember, Remember'),
    );
  }
}