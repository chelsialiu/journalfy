// A widget that displays the picture taken by the user.
import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Image.file(File(imagePath)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Caption",
                ),
              ),
            ),
            Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {},
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Text("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
