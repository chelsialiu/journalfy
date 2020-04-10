import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'camera_route.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key, this.title, this.camera}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final CameraDescription camera;
  final String title;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<CameraDescription>(builder: (context, camera, child) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Memories Now and Forever',
                    style: GoogleFonts.dancingScript(
                      textStyle: TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
              ),
              Divider(
                  color: Colors.grey, indent: 0, endIndent: 0, thickness: 10),
              ListTile(
                leading: Icon(Icons.event_note, color: Colors.green),
                title: Text('WRITE'),
                subtitle: Text('Jot down a few lines'),
              ),
              Divider(
                color: Colors.grey,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    trailing: Icon(Icons.camera_alt, color: Colors.green),
                    title: Text('CAPTURE'),
                    subtitle: Text('Take a picture worth a thousand words'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraRoute(camera: widget.camera),
                        ),
                      );
                    }),
              ),
              Divider(
                  color: Colors.grey, indent: 10, endIndent: 10, thickness: 5),
              ListTile(
                leading: Icon(Icons.videocam, color: Colors.green),
                title: Text('RECORD'),
                subtitle: Text('Tell a story and make a video'),
              ),
              Divider(
                  color: Colors.grey, indent: 10, endIndent: 10, thickness: 10),
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Our greatest need is to remember. \n ~ Spencer W. Kimball',
                    style: GoogleFonts.cinzel(
                      textStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    )
    ;
  }
}