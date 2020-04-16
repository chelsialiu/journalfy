import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:journalfy/route/notepad_route.dart';
import 'package:journalfy/route/video_recording_route.dart';
import 'package:journalfy/route/camera_route.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                      textStyle: TextStyle(fontSize: 26.0),
                    ),
                  ),
                ),
              ),
              Divider(
                  color: Colors.grey, indent: 0, endIndent: 0, thickness: 10),
              ListTile(
                leading: new LayoutBuilder(builder: (context, constraint){
                    return Icon(Icons.event_note, color: Colors.green, size: constraint.biggest.height);
                  }),
                title: Text('WRITE'),
                subtitle: Text('Jot down a few lines'),
                onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNote(),
                        ),
                      );
                    }
              ),
              Divider(
                color: Colors.grey,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: new LayoutBuilder(builder: (context, constraint){
                    return Icon(Icons.camera_alt, color: Colors.green, size: constraint.biggest.height);
                  }),
                    title: Text('CAPTURE'),
                    subtitle: Text('Take a picture worth a thousand words'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraRoute(),
                        ),
                      );
                    }),
              ),
              Divider(
                  color: Colors.grey, indent: 10, endIndent: 10, thickness: 5),
              ListTile(
                  leading: new LayoutBuilder(builder: (context, constraint){
                    return Icon(Icons.videocam, color: Colors.green, size: constraint.biggest.height);
                  }),
                  title: Text('RECORD'),
                  subtitle: Text('Tell a story and make a video'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoRoute(),
                      ),
                    );
                  }),
              Divider(
                  color: Colors.grey, indent: 10, endIndent: 10, thickness: 10),
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Our greatest need is to remember. \n ~ Spencer W. Kimball',
                    textAlign: TextAlign.center,
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
}
