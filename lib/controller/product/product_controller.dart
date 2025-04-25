import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:voltex/core/model/commint_model.dart';
import 'package:intl/intl.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/constants/images.dart';

class ProductController extends GetxController {
  String image3D = Images.gasCooker3D;
  late TextEditingController controller;
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

  final random = Random();
// addCommint({
//     required int itemId,
//     required String itemName,
//     required String comment,
//   }) async {
//     DateTime now = DateTime.now().toUtc();
//     String formattedDate = DateFormat(
//       "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
//     ).format(now);
//     if (await CheckInternet.checkInternet()) {
//       OverlayLoadingProgress.start();
//       try {
//         statusRequest = StatusRequest.loading;

//         var response = await categoriesRepository.postCommint(
//           dateAdd: formattedDate,
//           itemName: itemName,
//           itemId: itemId,
//           comment: comment,
//         );

//         if (response.statusCode == 200) {
//           // item = ItemsResponse.fromJson(response.body);
//           // // item2.first = item!;
//           print('commint ${response.body}');
//           controller.clear();
//         }

//         await getAllCommintByCategoryId(itemId);
//         update();
//         OverlayLoadingProgress.stop();
//       } catch (e) {
//         showCustomSnackBar(
//           'An error occurred. Please try again.'.tr,
//           isError: true,
//         );
//         OverlayLoadingProgress.stop();
//         print('Error during get category: $e');
//       }
//     } else {
//       OverlayLoadingProgress.stop();
//       showCustomSnackBar('Check the internet connection'.tr, isError: true);
//     }
//   }

  addCommints({required String id}) async {
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat(
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    ).format(now);
    String? user = await AppUsageService.getUserName();
    productDB.doc(id).collection('commints').add({
      'userName': user,
      'commint': controller.text,
      'rate': (random.nextInt(5) + 1).toString(),
      'dateAdd': formattedDate
    }).then((DocumentReference docs) {
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
    QuerySnapshot commints = await FirebaseFirestore.instance
        .collection("items")
        .doc(id)
        .collection('commints')
        .get();
    for (var com in commints.docs) {
      listCommints.add(CommintModel(
        commint: com['commint'],
        userName: com['userName'],
        rate: com['rate'],
      ));
      if (isNewCommint) {
        countRates++;
        totaleRate = totaleRate + double.parse(com['rate']);
      }
    }
    newRate = totaleRate / countRates;
    if (isNewCommint) {
      FirebaseFirestore.instance.collection("items").doc(id).update({
        'rate': newRate.toString(),
      }).then((value) {
        isNewCommint = false;
        print(" to update rate: value");
      }).catchError((error) => print("Failed to update rate: $error"));
    }
    DocumentSnapshot data =
        await FirebaseFirestore.instance.collection("items").doc(id).get();
    rate = double.parse(data['rate']).toStringAsFixed(1);
    print('rate==${rate}');
    update();
  }

  @override
  void dispose() {
    // item2 = <Item>[].obs;
    controller.dispose();

    super.dispose();
  }
}
