import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green, // Figure out how to change color to RGBA (107,164,16,1)
      ),
      home: MyHomePage(title: 'O Remember, Remember'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                  child: Text('Memories Now and Forever', 
                  style: GoogleFonts.dancingScript(
                    textStyle: TextStyle(fontSize: 24.0),
                  ),
                  ),
                ),
              ),
              Divider(color: Colors.grey, indent: 0, endIndent: 0, thickness: 10),
              ListTile(
                leading: Icon(Icons.event_note, color: Colors.green),
                title: Text('WRITE'),
                subtitle: Text('Jot down a few lines'),
              ),
              Divider(color: Colors.grey, thickness: 5, ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Icon(Icons.camera_alt, color: Colors.green),
                  title: Text('CAPTURE'),
                  subtitle: Text('Take a picture worth a thousand words'),
                ),
              ),
              Divider(color: Colors.grey, indent: 10, endIndent: 10, thickness: 5),
              ListTile(
                leading: Icon(Icons.videocam, color: Colors.green),
                title: Text('RECORD'),
                subtitle: Text('Tell a story and make a video'),
              ),
              Divider(color: Colors.grey, indent: 10, endIndent: 10, thickness: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text('Our greatest need is to remember. \n \t ~ Spencer W. Kimball', 
                  style: GoogleFonts.dancingScript(
                    textStyle: TextStyle(fontSize: 20.0),
                  ),
                  ),
                ),
              ),
            ],
          ),
      ),
      );
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
  }
}
