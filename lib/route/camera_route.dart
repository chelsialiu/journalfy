// A screen that takes in a list of cameras and the Directory to store images.
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:journalfy/route/gallery_view_route.dart';
import 'package:path/path.dart' as path;

class CameraRoute extends StatefulWidget {
  const CameraRoute({Key key}) : super(key: key);

  @override
  CameraRouteState createState() => CameraRouteState();
}

class CameraRouteState extends State<CameraRoute>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(title: Text("CAPTURE a Picture")),
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(context),
          // NEEDSWORK
          // Potentially add other camera functionalities here (i.e. Zoom, flash, etc)
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCameraPreview(context) {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(context) {
    return Container(
      color: Theme.of(context).bottomAppBarColor,
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FutureBuilder(
            future: getLastImage(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  width: 40.0,
                  height: 40.0,
                );
              }
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Gallery(),
                  ),
                ),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: ClipOval(
                    child: Image.file(
                      snapshot.data,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                Icons.camera_alt,
                size: 28.0,
                color: Colors.white,
              ),
              onPressed: () {
                _captureImage();
              },
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 24.0,
            child: IconButton(
              icon: Icon(
                Icons.switch_camera,
                size: 24.0,
                color: Colors.white,
              ),
              onPressed: () {
                _onCameraSwitch();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<FileSystemEntity> getLastImage() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    var lastFile = _images[0];
    var extension = path.extension(lastFile.path);
    if (extension == '.jpeg') {
      return lastFile;
    } else {
      String thumb = await Thumbnails.getThumbnail(
          videoFile: lastFile.path, imageType: ThumbFormat.PNG, quality: 30);
      return File(thumb);
    }
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() async {
    print('_captureImage');
    if (_controller.value.isInitialized) {
      SystemSound.play(SystemSoundType.click);
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      print('path: $filePath');
      await _controller.takePicture(filePath);
      setState(() {});
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}
