import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:journalfy/route/camera_route.dart';
import 'package:journalfy/route/home_route.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.isNotEmpty ? cameras.first : null;

  return runApp(MyApp(firstCamera));
}

// Needed a Stateful constructor that would take firstCamera as an argument
class MyApp extends StatefulWidget {
  final mainCamera;

  MyApp(this.mainCamera);

  @override
  _MyAppState createState() => _MyAppState();
}

// What is the relationship between this _MyAppState and the previous MyApp??
// This manages the State of the MyApp
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<CameraDescription>(
      create: (context) => widget.mainCamera,
      child: MaterialApp(
        title: 'Journalfy',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". Then, invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          primarySwatch: Colors
              .green, // Figure out how to change color to RGBA (107,164,16,1)
        ),
        home: HomeRoute(title: 'O Remember, Remember', camera: widget.mainCamera,),
      ),
    );
  }
}
