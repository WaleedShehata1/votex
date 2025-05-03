import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voltex/core/model/commint_model.dart';
import 'package:intl/intl.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/constants/images.dart';

class ProductController extends GetxController {
  String image3D = Images.gasCooker3D;
  int rateProduct = 0;
  late TextEditingController controller;
  ScreenshotController screenshotController = ScreenshotController();
  Future<void> takeScreenshotAndShare(sentence) async {
    try {
      // Capture the widget as bytes
      final imageBytes = await screenshotController.capture();
      if (imageBytes == null) throw Exception("Screenshot failed");

      // Save the image locally
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/screenshot.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // Share the image + sentence

      await Share.shareXFiles([XFile(filePath)], text: sentence);
    } catch (e) {
      print('Error taking screenshot and sharing: $e');
    }
  }

  selectImage3D(String image) {
    switch (image) {
      case 'بوتجاز':
      case "Stove":
        image3D = Images.gasCooker3D;
        break;
      case 'ثلاجة':
      case "Refrigerator":
        image3D = Images.refrigerator3D;
        break;
      case 'تكييف':
      case "Air conditioner":
        image3D = Images.conditioning3D;
        break;
      case 'ديب فريزر':
      case "Deep freezer":
        image3D = Images.deepFreezer3D;
        break;
      case 'سيشوار':
      case "Hair dryer":
        image3D = Images.blowDryer3D;
        break;
      case 'شاشة':
      case "Screen TV":
        image3D = Images.screen3D;
        break;
      case "غسالة ملابس":
      case "Washing machine":
        image3D = Images.washing3D;
        break;
      case "ماكينة صنع قهوة":
      case "Coffee maker":
        image3D = Images.coffee3D;
        break;
      case 'مايكروويف':
      case "Microwave":
        image3D = Images.microwave3D;
        break;
      case "مروحة حائطية":
      case "Wall fan":
        image3D = Images.wallFan3D;
        break;
      case "مروحة عمودية":
      case "Stand fan":
        image3D = Images.pillarFan3D;
        break;
      case "مكنسة كهربائية":
      case "Vacuum cleaner":
        image3D = Images.vacuumCleaner3D;
        break;
      case "مكواة شعر":
      case "Hair straightener":
        image3D = Images.hairStraightener3D;
        break;
      case 'مكواة':
      case "Iron":
        image3D = Images.iron3D;
        break;
    }
  }

  String rate = '';
  bool isNewCommint = false;
  List<CommintModel> listCommints = [];
  final productDB = FirebaseFirestore.instance.collection("items");
  @override
  void onInit() {
    controller = TextEditingController();
    super.onInit();
  }

  addCommints({required String id, required int rates}) async {
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat(
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    ).format(now);
    String? user = await AppUsageService.getUserName();
    productDB
        .doc(id)
        .collection('commints')
        .add({
          'userName': user,
          'commint': controller.text,
          'rate': rates.toString(),
          'dateAdd': formattedDate,
        })
        .then((DocumentReference docs) {
          print("object==> ${docs.id}");
        });
    controller.clear();
    isNewCommint = true;
    getCommints(id: id);
  }

  getCommints({required String id}) async {
    double totaleRate = 0.0;
    int countRates = 0;
    double newRate = 0.0;
    listCommints = [];
    QuerySnapshot commints =
        await FirebaseFirestore.instance
            .collection("items")
            .doc(id)
            .collection('commints')
            .get();
    for (var com in commints.docs) {
      listCommints.add(
        CommintModel(
          commint: com['commint'],
          userName: com['userName'],
          rate: (com['rate']).toString(),
        ),
      );
      if (isNewCommint) {
        countRates++;
        totaleRate = totaleRate + double.parse((com['rate']).toString());
      }
    }
    newRate = totaleRate / countRates;
    if (isNewCommint) {
      FirebaseFirestore.instance
          .collection("items")
          .doc(id)
          .update({'rate': newRate.toString()})
          .then((value) {
            isNewCommint = false;
            print(" to update rate: value");
          })
          .catchError((error) => print("Failed to update rate: $error"));
    }
    DocumentSnapshot data =
        await FirebaseFirestore.instance.collection("items").doc(id).get();
    rate = double.parse(data['rate']).toStringAsFixed(1);
    print('rate==${rate}');
    rateProduct = 0;
    Get.back();
    update();
  }

  @override
  void dispose() {
    // item2 = <Item>[].obs;
    controller.dispose();

    super.dispose();
  }
}
