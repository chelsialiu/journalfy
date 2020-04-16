// A screen that takes in a list of cameras and the Directory to store images.
// LOOK INTO THIS: https://github.com/flutter-devs/flutter_video_recorder | https://www.woolha.com/tutorials/flutter-video-capture-example
// And this: https://github.com/divyanshub024/flutter_camera/tree/master/lib
// Resource: https://levelup.gitconnected.com/exploring-flutter-camera-plugin-d2c54ac95f05
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:journalfy/route/gallery_view_route.dart';
import 'package:journalfy/route/video_timer.dart';
import 'package:path/path.dart' as path;

class VideoRoute extends StatefulWidget {
  const VideoRoute({Key key}) : super(key: key);

  @override
  VideoRouteState createState() => VideoRouteState();
}

class VideoRouteState extends State<VideoRoute>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // bool _isRecordingMode = true;
  bool _isRecording = false;
  final _timerKey = GlobalKey<VideoTimerState>();

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  Future<void> _initVideo() async {
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
      appBar: AppBar(title: Text("RECORD a Story")),
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(context),
          // NEEDSWORK
          // Potentially add other functionalities here (i.e. Zoom, flash, etc)
          Positioned(
            left: 0,
            right: 0,
            top: 32.0,
            child: VideoTimer(
              key: _timerKey,
            ),
          )
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
            backgroundColor: Colors.grey[300],
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                (_isRecording) ? Icons.stop : Icons.fiber_manual_record,
                size: 28.0,
                color: (_isRecording) ? Colors.black : Colors.red,
              ),
              onPressed: () {
                if (_isRecording) {
                  stopVideoRecording();
                } else {
                  startVideoRecording();
                }
              },
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 24.0,
            child: IconButton(
              icon: Icon(
                  (!_isRecording) ? Icons.switch_video : Icons.switch_video,
                  color: (!_isRecording) ? Colors.white : Colors.grey),
              onPressed: () {
                (!_isRecording) ? _onVideoSwitch() : null;
                ;
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
      print(dirPath);
      String thumb = await Thumbnails.getThumbnail(
          videoFile: lastFile.path, imageType: ThumbFormat.PNG, quality: 30);
      return File(thumb);
    }
  }

  Future<void> _onVideoSwitch() async {
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

  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    if (!_controller.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    _timerKey.currentState.startTimer();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    _timerKey.currentState.stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
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
