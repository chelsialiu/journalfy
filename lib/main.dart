import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:journalfy/route/home_route.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.isNotEmpty ? cameras.first : null;

  return runApp(MyApp(firstCamera);
}

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