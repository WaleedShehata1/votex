import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:quiver/time.dart';

class CameraControllerl extends GetxController {
  // late CameraController cameraController;
  // Rx<bool> isInitialize = Rx(false);
  // Future loadDataModel() async {
  //   await Tflite.loadModel(
  //     model: 'assets/model/vww_96_grayscale_quantized.tflite',
  //     labels: 'assets/model/labels.txt',
  //   );
  // }

  // @override
  // void onInit() {
  //   loadDataModel();

  //   super.onInit();
  // }

  // bool loading = true;
  // File? image;
  // List output = [];
  // dectectImage(File image) async {
  //   var out = await Tflite.runModelOnImage(
  //     path: image.path,
  //     numResults: 2,
  //     threshold: 0.6,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //   );
  //   output = out!;
  //   loading = false;
  //   update();
  // }

  // Future initializeCamera() async {
  //   final camera = await availableCameras();
  //   cameraController = CameraController(camera[0], ResolutionPreset.medium);
  //   await cameraController.initialize();
  //   isInitialize.value = true;
  // }
}
