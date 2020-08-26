import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:omsk_seaty_mobile/blocs/add_image/add_image_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/geopoint.dart';
import 'package:omsk_seaty_mobile/ui/utils/geocoder.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddPhotoCameraScreen extends StatefulWidget {
  const AddPhotoCameraScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddPhotoCameraScreenState();
  }
}

class _AddPhotoCameraScreenState extends State<AddPhotoCameraScreen> {
  CameraController _controller;
  Future<void> _initControllerFuture;

  @override
  void initState() {
    super.initState();
    _initControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    await _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller?.value?.isInitialized != true) return Container();
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        NativeDeviceOrientationReader(builder: (context) {
          NativeDeviceOrientation orientation =
              NativeDeviceOrientationReader.orientation(context);

          final deviceRatio = size.width < size.height
              ? size.width / size.height
              : size.height / size.width;
          int turns;
          switch (orientation) {
            case NativeDeviceOrientation.landscapeLeft:
              turns = -1;
              break;
            case NativeDeviceOrientation.landscapeRight:
              turns = 1;
              break;
            case NativeDeviceOrientation.portraitDown:
              turns = 2;
              break;
            default:
              turns = 0;
              break;
          }

          return RotatedBox(
              quarterTurns: turns,
              child: Transform.scale(
                  scale: _controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller), //cameraPreview
                    ),
                  )));
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildTakePhotoButton(context),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildTakePhotoButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(64),
      height: 56,
      width: 56,
      child: RawMaterialButton(
        onPressed: () async => _takePhoto(context),
        fillColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.photo_camera,
          color: Theme.of(context).iconTheme.color,
          size: 32.0,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  void _takePhoto(BuildContext context) async {
    //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        "bench${DateTime.now()}.png",
      );
      await _controller.takePicture(path); //take photo
      Navigator.of(context).pop(path);
    } catch (e) {
      print(e);
    }
  }
}
