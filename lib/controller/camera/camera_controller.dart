import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CameraController extends GetxController {
  List<String> imageUrls = [];
  bool isLoading = true;
  Future<void> fetchImagesFromFolder() async {
    final storageRef = FirebaseStorage.instance.ref();
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat("2025-05-31").format(now);
    print(formattedDate);
    final folderRef = storageRef
        .child('fruits')
        .child(formattedDate); // replace with your folder

    try {
      final ListResult result = await folderRef.listAll();
      List<String> urls = [];

      for (var item in result.items) {
        String url = await item.getDownloadURL();
        urls.add(url);
      }

      imageUrls = urls;
      isLoading = false;
      update();
    } catch (e) {
      print('Error fetching images: $e');

      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchImagesFromFolder();
    super.onInit();
  }
}
