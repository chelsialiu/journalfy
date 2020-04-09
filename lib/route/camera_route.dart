// A screen that takes in a list of cameras and the Directory to store images.
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraRoute extends StatefulWidget {
  final CameraDescription camera;

  const CameraRoute({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraRouteState createState() => CameraRouteState();
}

class CameraRouteState extends State<CameraRoute> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
   // Establishes a conection to the device's camera that allows you to control the camera and display a preview of the camera's feed
  CameraController _controller;
  Future<void> _initializeControllerFuture; // stores the Future retruend form CameraController.intialize()

  @override
  void initState() { // Must intialize the CameraController to display a preview and take pictures
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You must wait until the controller is initialized before displaying the
    // camera preview. Use a FutureBuilder to display a loading spinner until the
    // controller has finished initializing.
    FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_controller);
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
