import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/widget/custom_image_widget.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImagesFromFolder();
  }

  Future<void> fetchImagesFromFolder() async {
    final storageRef = FirebaseStorage.instance.ref();
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat("yyyy-MM-dd").format(now);
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

      setState(() {
        imageUrls = urls;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Images')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Images')),
      body:
          imageUrls.isEmpty
              ? Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'The refrigerator is empty',
                    style: TextStyle(fontSize: 28.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomImageWidget(
                      image: imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
    );
  }
}
