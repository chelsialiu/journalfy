import 'package:flutter/material.dart';
import 'package:journalfy/route/home_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journalfy',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeRoute(title: 'O Remember, Remember'),
    );
  }
}
