import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:voltex/core/model/item_model.dart';
import 'dart:math';
import 'package:faker/faker.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/model/brand_model.dart';
import '../../core/model/subcategory_model.dart';
import '../../core/model/user_model.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../features/store/store_screen.dart';
import '../LocalizationController.dart';

abstract class HomeController extends GetxController {
  // getAllBrand();
}

class HomeControllerImp extends HomeController {
  final LocalizationController localizationController = Get.put(
    LocalizationController(sharedPreferences: Get.find()),
  );
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // show a simple notification
  // static Future showSimpleNotification({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //         'your channel id',
  //         'your channel name',
  //         channelDescription: 'your channel description',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         ticker: 'ticker',
  //       );
  //   const NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //   );
  //   await _flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     notificationDetails,
  //     payload: payload,
  //   );
  // }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
  String? selectType;
  List<DropdownMenuItem<Object>>? selectTypeList;
  final users = FirebaseFirestore.instance.collection('users');
  String? filtter;
  List<String> filtterList = [
    'normal',
    "price LowToHig",
    "price HighToLow",
    "oldest First",
    "newest First",
    "from A To Z",
    "from Z To A",
  ];
  final itemListSearch = <ItemModel>[].obs;
  var isLoadingSearch = false.obs;
  Rx<BrandModel>? brandModel;
  var isLoadingGetAllBrand = false.obs;
  String? brand;
  String? sub;
  UserModel? model;
  List<SubcategoryModel> listSubCategoryes = [];
  // List<QueryDocumentSnapshot> listBrands2 = [];
  List<ItemModel> filtterListItem = [];
  List<ItemModel> listItem = [];
  List<ItemModel> listItemAndFiltter = [];
  List<ItemModel> listItemOffer = [];
  // List<QueryDocumentSnapshot> listBrands2 = [];
  List<BrandModel> listBrands = [];
  List<QueryDocumentSnapshot> listBrands2 = [];
  final List<ItemModel> _products = [];
  List<ItemModel> get getProducts {
    return _products;
  }

  final List<BrandModel> _brands = [];
  List<BrandModel> get getBrande {
    return _brands;
  }

  final productDB = FirebaseFirestore.instance.collection("items");
  final brandDB = FirebaseFirestore.instance.collection("brads");

  @override
  void onInit() {
    load();
    fetchBrand();
    getUserData();
    super.onInit();
  }

  // create items to firebase
  var data = [
    {
      "itemName": "Samsung  TV QN900D Neo QLED",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.43_0009a600.jpg?alt=media&token=f3dcc1e0-9cfc-4484-b090-d531e790e6c9",
      "itemDescription":
          "Resolution: 8K , Display Technology: Quantum Mini LEDs ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0 , Available Sizes : 65 ,Unique Features: AI-powered upscaling for enhanced picture quality.",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.43_0009a600.jpg?alt=media&token=f3dcc1e0-9cfc-4484-b090-d531e790e6c9",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "144999",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "5",
    },
    {
      "itemName": "Samsung  TV QN850D Neo QLED",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.43_6e04114d.jpg?alt=media&token=2674881a-b866-4b3b-8e58-c0822985dcc0",
      "itemDescription":
          "Resolution: 8K , Display Technology: Quantum Mini LEDs ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 55 ,Unique Features: Slim design with Object Tracking Sound Pro.",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.43_6e04114d.jpg?alt=media&token=2674881a-b866-4b3b-8e58-c0822985dcc0",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "73999",
      "rate": "5",
      "stock": "14",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "2",
    },
    {
      "itemName": "Samsung  TV QN800D Neo QLED",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_0cc7f362.jpg?alt=media&token=25f41c6a-f2b0-420d-9b7a-d611d9641068",
      "itemDescription":
          "Resolution: 8K , Display Technology: Quantum Mini LEDs ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: AI upscaling and anti-glare screen.",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_0cc7f362.jpg?alt=media&token=25f41c6a-f2b0-420d-9b7a-d611d9641068",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "67999",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "5",
    },
    {
      "itemName": "Samsung  TV G80SD  QLED",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_1a132a09.jpg?alt=media&token=10d4a25e-e9af-485f-90e5-0e5421b72bcb",
      "itemDescription":
          "Resolution: 4K , Display Technology:Quantum Dot ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: Ultra-slim design, cinematic sound.",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_1a132a09.jpg?alt=media&token=10d4a25e-e9af-485f-90e5-0e5421b72bcb",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "35999",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "8",
    },
    {
      "itemName": "Samsung  TV G95SD  QLED",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_1baa3997.jpg?alt=media&token=3c84be3e-1502-4e58-9efe-415a36d4d7b8",
      "itemDescription":
          "Resolution: 4K , Display Technology:Quantum Dot ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: Superior motion clarity with 144Hz refresh rate.",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_1baa3997.jpg?alt=media&token=3c84be3e-1502-4e58-9efe-415a36d4d7b8",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "41999",
      "rate": "5",
      "stock": "30",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "2",
    },
    {
      "itemName": "Samsung  TV The Frame Lifestyle Series",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_1fa7cb59.jpg?alt=media&token=cda53101-25ba-470f-a56b-60542e742c9b",
      "itemDescription":
          "Resolution: 4K , Display Technology:Quantum Dot ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: Customizable frames, Art Mode to display artwork when idle.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_1fa7cb59.jpg?alt=media&token=cda53101-25ba-470f-a56b-60542e742c9b",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "13699",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "3",
    },
    {
      "itemName": "Samsung  TV The Serif Lifestyle Series",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_3d22d9b6.jpg?alt=media&token=7916f0b9-474a-449b-b246-e7c205c4cfc8",
      "itemDescription":
          "Resolution: 4K , Display Technology:Quantum Dot ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: Iconic design with 360-degree viewing angle.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_3d22d9b6.jpg?alt=media&token=7916f0b9-474a-449b-b246-e7c205c4cfc8",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "13399",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "5",
    },
    {
      "itemName": "Samsung  TV The Sero Lifestyle Series",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_44d42323.jpg?alt=media&token=7388d576-8f75-4839-a91a-d9c444e2e095",
      "itemDescription":
          "Resolution: 4K , Display Technology:Quantum Dot ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: Rotates between landscape and portrait for mobile content.",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_44d42323.jpg?alt=media&token=7388d576-8f75-4839-a91a-d9c444e2e095",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "13659",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "1",
    },
    {
      "itemName": "Samsung  TV DU8000 Crystal UHD",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_5d9be67e.jpg?alt=media&token=1cce096d-2316-4d9d-9296-c47a4a50d914",
      "itemDescription":
          "Resolution: 4K , Display Technology:Crystal Processor ,HDR Support: HDR10+  ,Smart OS: Tizen 8.0  , Available Sizes : 65 ,Unique Features: Budget-friendly option with vivid colors and solid upscaling.",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_5d9be67e.jpg?alt=media&token=1cce096d-2316-4d9d-9296-c47a4a50d914",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "13399",
      "rate": "5",
      "stock": "1",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "0",
    },
    {
      "itemName": "Symphony SY-LED 32 SM-D LED",
      "brandName": "Symphony",
      "brandId": "H0UD2Ns0qY0KutoBbwPl",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_67119429.jpg?alt=media&token=5fce33de-e33c-4f7a-806a-ec7053acffb8",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified  ,Smart OS: Not specified  , Available Sizes : 32 ,Unique Features: Budget-friendly Full HD LED TV.",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_67119429.jpg?alt=media&token=5fce33de-e33c-4f7a-806a-ec7053acffb8",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "5000",
      "rate": "5",
      "stock": "22",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "2",
    },
    {
      "itemName": "Symphony SY-LED 43 SM-D LED",
      "brandName": "Symphony",
      "brandId": "H0UD2Ns0qY0KutoBbwPl",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_7e95a742.jpg?alt=media&token=d1906831-d1e2-4445-bbc1-d5b5ce0b9470",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified  ,Smart OS: Not specified  , Available Sizes : 43 ,Unique Features: Affordable Full HD LED TV with standard features.",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_7e95a742.jpg?alt=media&token=d1906831-d1e2-4445-bbc1-d5b5ce0b9470",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "7000",
      "rate": "5",
      "stock": "20",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "4",
    },
    {
      "itemName": "Symphony SY-LED 52 SM-E LED",
      "brandName": "Symphony",
      "brandId": "H0UD2Ns0qY0KutoBbwPl",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_80f2f764.jpg?alt=media&token=7d8385b7-1550-485e-b2f8-d6dea3603142",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified  ,Smart OS: Not specified  , Available Sizes : 52 ,Unique Features: Affordable Full HD LED TV with standard features.",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_80f2f764.jpg?alt=media&token=7d8385b7-1550-485e-b2f8-d6dea3603142",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "10000",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "3",
    },
    {
      "itemName": "Symphony SY-LED 59 SM-E LED",
      "brandName": "Symphony",
      "brandId": "H0UD2Ns0qY0KutoBbwPl",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8a9653d6.jpg?alt=media&token=6249e525-69dd-4439-b50a-8e2764e11fd1",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified  ,Smart OS: Not specified  , Available Sizes : 59,Unique Features: Affordable Full HD LED TV with standard features.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8a9653d6.jpg?alt=media&token=6249e525-69dd-4439-b50a-8e2764e11fd1",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "12000",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "2",
    },
    {
      "itemName": "ATA32H0N Standard LED",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8b0560f9.jpg?alt=media&token=527ddca6-0466-4189-b076-a3b6852f6d62",
      "itemDescription":
          "Resolution:HD , Display Technology: LED ,HDR Support: Not specified ,Smart OS: Not specified   , Available Sizes : 32 ,Unique Features: Budget-friendly HD LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8b0560f9.jpg?alt=media&token=527ddca6-0466-4189-b076-a3b6852f6d62",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "5450",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "4",
    },
    {
      "itemName": "ATA32H0S Smart LED",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8bca8b87.jpg?alt=media&token=7f030482-6a49-4acb-bf28-687ace910cd4",
      "itemDescription":
          "Resolution: HD , Display Technology: LED ,HDR Support: Not specified  ,Smart OS: Android   , Available Sizes : 32 ,Unique Features: HD LED Smart TV with Android OS. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8bca8b87.jpg?alt=media&token=7f030482-6a49-4acb-bf28-687ace910cd4",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "5581",
      "rate": "5",
      "stock": "23",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "2",
    },
    {
      "itemName": "ATA43F0S Smart LED",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8c9c4914.jpg?alt=media&token=4fe4f7f1-55ea-4cb6-909c-ecb3d7055003",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified   ,Smart OS: Android , Available Sizes : 43 ,Unique Features: Full HD LED Smart TV with Android OS. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8c9c4914.jpg?alt=media&token=4fe4f7f1-55ea-4cb6-909c-ecb3d7055003",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "7449",
      "rate": "5",
      "stock": "25",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "3",
    },
    {
      "itemName": "ATA43S1 Smart LED",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8f85723d.jpg?alt=media&token=b77a76f4-8059-4d83-86fc-4a867efab194",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified  ,Smart OS: Not specified  , Available Sizes : 43  ,Unique Features: Full HD LED Smart TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_8f85723d.jpg?alt=media&token=b77a76f4-8059-4d83-86fc-4a867efab194",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "8189",
      "rate": "5",
      "stock": "40",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "ATA55U0S Smart LED",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_960ab5b9.jpg?alt=media&token=02521648-7c02-4b5f-96de-a51934ef75b6",
      "itemDescription":
          "Resolution: 4K UHD , Display Technology: LED ,HDR Support: Not specified ,Smart OS: Not specified   , Available Sizes : 55 ,Unique Features: 4K UHD Smart LED TV.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_960ab5b9.jpg?alt=media&token=02521648-7c02-4b5f-96de-a51934ef75b6",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "14999",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "ATA55E4K1 Standard LED",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_a4b2b62e.jpg?alt=media&token=caabb816-646b-41ca-b046-345055e535c9",
      "itemDescription":
          "Resolution: 4K UHD , Display Technology: LED ,HDR Support: Not specified ,Smart OS: Not specified   , Available Sizes : 55 ,Unique Features: 4K UHD LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_a4b2b62e.jpg?alt=media&token=caabb816-646b-41ca-b046-345055e535c9",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "15271",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 32EL8250E-B Standard LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_ac7106d9.jpg?alt=media&token=d226fe59-36f1-4073-ba77-559450c44b8a",
      "itemDescription":
          "Resolution: HD , Display Technology: LED  ,HDR Support: Not specified ,Smart OS: Not specified   , Available Sizes : 32 ,Unique Features:Budget-friendly HD LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_ac7106d9.jpg?alt=media&token=d226fe59-36f1-4073-ba77-559450c44b8a",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "7299",
      "rate": "5",
      "stock": "20",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 32ES9300E-A Smart LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_af0a8426.jpg?alt=media&token=6ef5b00e-2b0e-476c-9928-536b7d088fe1",
      "itemDescription":
          "Resolution: HD , Display Technology: LED  ,HDR Support: Not specified ,Smart OS: Not specified   , Available Sizes : 32 ,Unique Features: 4K UHD LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_af0a8426.jpg?alt=media&token=6ef5b00e-2b0e-476c-9928-536b7d088fe1",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "7999",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 43ES1500E Smart LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_ba7e8948.jpg?alt=media&token=b9df468a-be7e-4ac6-aee3-3712219f3997",
      "itemDescription":
          "Resolution: Full HD , Display Technology: LED ,HDR Support: Not specified ,Smart OS: Not specified    , Available Sizes : 43 ,Unique Features: HD LED Smart TV with Android OS. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_ba7e8948.jpg?alt=media&token=b9df468a-be7e-4ac6-aee3-3712219f3997",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "8189",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 50US1500E Smart LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_bbfe9fbe.jpg?alt=media&token=2c22c1ef-cbea-473c-a905-f82ecf4c1a2e",
      "itemDescription":
          "Resolution: 4K UHD , Display Technology: LED ,HDR Support: Not specified ,Smart OS: Not specified    , Available Sizes : 50 ,Unique Features:Full HD LED Smart TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_bbfe9fbe.jpg?alt=media&token=2c22c1ef-cbea-473c-a905-f82ecf4c1a2e",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "14999",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 50US3500E Smart LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_e369067a.jpg?alt=media&token=b64e1125-2f09-402e-b8fa-9986159b9486",
      "itemDescription":
          "Resolution: 4K UHD , Display Technology: DLED ,HDR Support: Not specified ,Smart OS: Not specified    , Available Sizes : 50 ,Unique Features: 4K UHD Smart LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_e369067a.jpg?alt=media&token=b64e1125-2f09-402e-b8fa-9986159b9486",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "18799",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 55US3500E Smart LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_e3f4ac28.jpg?alt=media&token=c4050bd5-6506-44d5-8208-a908aec5b08d",
      "itemDescription":
          "Resolution: 4K UHD , Display Technology: DLED  ,HDR Support: Not specified ,Smart OS: Not specified    , Available Sizes : 55 ,Unique Features: 4K UHD Smart LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_e3f4ac28.jpg?alt=media&token=c4050bd5-6506-44d5-8208-a908aec5b08d",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "20599",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO 65US3500E Smart LED",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_e5322aec.jpg?alt=media&token=9e31b8d0-48d1-4d21-8e3e-657f9471452d",
      "itemDescription":
          "Resolution: 4K UHD , Display Technology: DLED  ,HDR Support: Not specified ,Smart OS: Not specified    , Available Sizes : 65 ,Unique Features:4K UHD Smart LED TV. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-01%20%D9%81%D9%8A%2023.51.44_e5322aec.jpg?alt=media&token=9e31b8d0-48d1-4d21-8e3e-657f9471452d",
      "idSubCategory": "ItzjVkjkOg5wLdWgbUSG",
      "supCategory": "Screen TV",
      "price": "25299",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FSamsung%E2%80%99s%2065%20INCH%20FRAME%20%F0%9F%96%BC%EF%B8%8F%20Art%20TV%20wall%20mounted.%20%23samsung%20%23qled%20%23qledtv%20%23samsungtv.mp4?alt=media&token=8832980a-bc06-40d9-840d-02662918c83e",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO AEW-8460SP Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0204.jpg?alt=media&token=753f9a06-2125-4191-9466-4a59f61daeba",
      "itemDescription":
          "Capacity: 8Kg   ,Color:  White    ,Features:  Inverter motor, 860 rpm spin speed, 5-year warranty. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0204.jpg?alt=media&token=753f9a06-2125-4191-9466-4a59f61daeba",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "10690",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO AW-DUK1300KUPEG Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0207.jpg?alt=media&token=d9b6bd42-3360-4618-8377-9a15a4cb24b0",
      "itemDescription":
          "Capacity: 13Kg   ,Color:  Silver    ,Features: Inverter motor, Great Waves Technology, I-Clean feature, Soft Close Lid, 15 Min Quick Wash. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0207.jpg?alt=media&token=d9b6bd42-3360-4618-8377-9a15a4cb24b0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "19399",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "1",
    },
    {
      "itemName": "TORNADO TW-BJ90S2EG Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "itemDescription":
          "Capacity: 8Kg   ,Color:  morandi Grey   ,Features:  Inverter motor, 1200 rpm spin speed, 5-year warranty. ",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "12000",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO AW-J800AUPEG Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0209.jpg?alt=media&token=037df1bb-fe27-4de0-81f1-39d0e470e2f3",
      "itemDescription":
          "Capacity: 8Kg   ,Color:  Silver    ,Features:  Inverter technology, energy-efficient, multiple wash programs. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0209.jpg?alt=media&token=037df1bb-fe27-4de0-81f1-39d0e470e2f3",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "11600",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "TORNADO TW-BK100GF4EG(MK) Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0213.jpg?alt=media&token=2c48afab-374e-4fd1-a6f2-dca29e82c474",
      "itemDescription":
          "Capacity: 9Kg   ,Color:  Silver    ,Features: Inverter technology, steam function, smart control via Wi-Fi. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0213.jpg?alt=media&token=2c48afab-374e-4fd1-a6f2-dca29e82c474",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "23499",
      "rate": "5",
      "stock": "14",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "8",
    },
    {
      "itemName": "TORNADO AW-DUK1300KUPEG(SK) Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "itemDescription":
          "Capacity: 13Kg   ,Color:  morandi Grey    ,Features:  Inverter technology, large capacity, multiple wash programs. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "17999",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO TW-BJ80S2EG(SK) Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0225.jpg?alt=media&token=fb5bb490-97ae-48e1-83f4-60485f8e967f",
      "itemDescription":
          "Capacity: 7Kg   ,Color:  White    ,Features:  Inverter technology, quick wash cycle, energy-efficient. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0225.jpg?alt=media&token=fb5bb490-97ae-48e1-83f4-60485f8e967f",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "16950",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO AW-J900DUPEG(SK) Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0228.jpg?alt=media&token=b70cf5db-0e80-4d8a-a90a-6e2b5970ed28",
      "itemDescription":
          "Capacity: 9Kg   ,Color:  White    ,Features: Inverter technology, digital display, multiple wash programs. ",
      "discount": "8",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0228.jpg?alt=media&token=b70cf5db-0e80-4d8a-a90a-6e2b5970ed28",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "12499",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO VH-1000S Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "itemDescription":
          "Capacity: 10Kg   ,Color:  White    ,Features: Half automatic, pump function, large capacity. ",
      "discount": "9",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "8259",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "TORNADO VH-720 Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "itemDescription":
          "Capacity: 7Kg   ,Color:  White    ,Features:  Half automatic, compact design, energy-efficient. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "6598",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "8",
    },
    {
      "itemName": "TORNADO AEW-E1050SUP Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0233.jpg?alt=media&token=e4f9f272-e8a4-40fc-808e-64e9d12466ed",
      "itemDescription":
          "Capacity: 10Kg   ,Color:  White    ,Features:  Inverter technology, pump function, large capacity. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0233.jpg?alt=media&token=e4f9f272-e8a4-40fc-808e-64e9d12466ed",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "15050",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "1",
    },
    {
      "itemName": "TORNADO AEW-E1150SUP(DS) Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0234.jpg?alt=media&token=0d8491a9-d659-43f6-8cad-8a3863db8b65",
      "itemDescription":
          "Capacity: 11Kg   ,Color:  White    ,Features:  Inverter technology, pump function, large capacity. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0234.jpg?alt=media&token=0d8491a9-d659-43f6-8cad-8a3863db8b65",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "17605",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "TORNADO AW-UK1100HUPEG Top Loading",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 11Kg   ,Color:  Silver    ,Features:  Inverter technology, large capacity, multiple wash programs. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "15999",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO TWT-TLN10LW Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "itemDescription":
          "Capacity: 10Kg   ,Color:  White    ,Features:  With pump, automatic washing and spinning, suitable for medium to large families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "11999",
      "rate": "5",
      "stock": "20",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "7",
    },
    {
      "itemName": "TORNADO TWT-TLN12LWT Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 12Kg   ,Color:  Dark Silver    ,Features:  With pump, automatic washing and spinning, suitable for large families. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "15100",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO TWT-TLN13RDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "itemDescription":
          "Capacity: 13Kg   ,Color:  Silver    ,Features:  With pump, automatic washing and spinning, suitable for large families. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "16699",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "TORNADO TWT-TLD15RSC Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0244.jpg?alt=media&token=54b32680-55d3-4bb9-9ee1-5a073f1e6f6d",
      "itemDescription":
          "Capacity: 15Kg   ,Color:  Stainless Steel    ,Features:  DDM Inverter technology, pump, suitable for large families. ",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0244.jpg?alt=media&token=54b32680-55d3-4bb9-9ee1-5a073f1e6f6d",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "23611",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO TWT-TLD17RSC Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0207.jpg?alt=media&token=d9b6bd42-3360-4618-8377-9a15a4cb24b0",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  White    ,Features: DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0207.jpg?alt=media&token=d9b6bd42-3360-4618-8377-9a15a4cb24b0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22589",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO TWT-TLD17RSS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Stainless Steel    ,Features:  DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22339",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "8",
    },
    {
      "itemName": "TORNADO TWT-TLN08LDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0209.jpg?alt=media&token=037df1bb-fe27-4de0-81f1-39d0e470e2f3",
      "itemDescription":
          "Capacity: 8Kg   ,Color:  Stainless Steel    ,Features:  With pump, automatic washing and spinning, suitable for small to medium families. ",
      "discount": "8",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0209.jpg?alt=media&token=037df1bb-fe27-4de0-81f1-39d0e470e2f3",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "10740",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO TWT-TLN09RSL Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0213.jpg?alt=media&token=2c48afab-374e-4fd1-a6f2-dca29e82c474",
      "itemDescription":
          "Capacity: 9Kg   ,Color:  Dark Silver    ,Features: With pump, automatic washing and spinning, suitable for medium families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0213.jpg?alt=media&token=2c48afab-374e-4fd1-a6f2-dca29e82c474",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "12599",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "7",
    },
    {
      "itemName": "TORNADO TWT-TLN10LSL Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "itemDescription":
          "Capacity: 10Kg   ,Color:  Silver    ,Features:  With pump, automatic washing and spinning, suitable for medium to large families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "14849",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO TWT-TLN12LDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "itemDescription":
          "Capacity: 12Kg   ,Color:  Silver    ,Features: With pump, automatic washing and spinning, suitable for large families. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "15949",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "TORNADO TWT-TLN13RSL Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0233.jpg?alt=media&token=e4f9f272-e8a4-40fc-808e-64e9d12466ed",
      "itemDescription":
          "Capacity: 13Kg   ,Color:  Dark Silver    ,Features: With pump, automatic washing and spinning, suitable for large families. ",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0233.jpg?alt=media&token=e4f9f272-e8a4-40fc-808e-64e9d12466ed",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "16999",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "TORNADO TWT-TLD15RDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0234.jpg?alt=media&token=0d8491a9-d659-43f6-8cad-8a3863db8b65",
      "itemDescription":
          "Capacity: 15Kg   ,Color:  Silver    ,Features:  DDM Inverter technology, pump, suitable for large families. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0234.jpg?alt=media&token=0d8491a9-d659-43f6-8cad-8a3863db8b65",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "20499",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "TORNADO TWT-TLD17RDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Dark Silver    ,Features: DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "8",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "23399",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "8",
    },
    {
      "itemName": "TORNADO TWT-TLD17RS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Silver    ,Features: DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22399",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO TWT-TLD15RSC Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 15Kg   ,Color:  Silver    ,Features:  DDM Inverter technology, pump, suitable for large families. ",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "21133",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO TWT-TLD17RSC Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Stainless Steel    ,Features:  DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "8",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22499",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO TWT-TLD17RSS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0244.jpg?alt=media&token=54b32680-55d3-4bb9-9ee1-5a073f1e6f6d",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Stainless Steel    ,Features:  DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0244.jpg?alt=media&token=54b32680-55d3-4bb9-9ee1-5a073f1e6f6d",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22399",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "9",
    },
    {
      "itemName": "TORNADO TWT-TLD15RDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0233.jpg?alt=media&token=e4f9f272-e8a4-40fc-808e-64e9d12466ed",
      "itemDescription":
          "Capacity: 15Kg   ,Color:  Silver    ,Features:  DDM Inverter technology, pump, suitable for large families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0233.jpg?alt=media&token=e4f9f272-e8a4-40fc-808e-64e9d12466ed",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "20499",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "TORNADO TWT-TLD17RDS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0234.jpg?alt=media&token=0d8491a9-d659-43f6-8cad-8a3863db8b65",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Dark Silver    ,Features:  DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0234.jpg?alt=media&token=0d8491a9-d659-43f6-8cad-8a3863db8b65",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22399",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO TWT-TLD17RSS Top Automatic",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 17Kg   ,Color:  Stainless Steel    ,Features: DDM Inverter technology, pump, suitable for very large families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22399",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "SHARP ES-TN09GDSP Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0209.jpg?alt=media&token=037df1bb-fe27-4de0-81f1-39d0e470e2f3",
      "itemDescription":
          "Capacity: 9Kg   ,Color:  Stainless Steel    ,Features: Automatic, pump, 9 kg capacity, dark silver color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0209.jpg?alt=media&token=037df1bb-fe27-4de0-81f1-39d0e470e2f3",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "14569",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "SHARP ES-TN11GDSP Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0213.jpg?alt=media&token=2c48afab-374e-4fd1-a6f2-dca29e82c474",
      "itemDescription":
          "Capacity: 11Kg   ,Color:   Dark Silver   ,Features: Automatic, pump, 11 kg capacity, dark silver color. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0213.jpg?alt=media&token=2c48afab-374e-4fd1-a6f2-dca29e82c474",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "17699",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "SHARP ES-TN13GDSP Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "itemDescription":
          "Capacity: 13Kg   ,Color:  Stainless Steel    ,Features: Automatic, pump, 13 kg capacity, dark silver color. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "18699",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "SHARP ES-FP710CXE-S Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0225.jpg?alt=media&token=fb5bb490-97ae-48e1-83f4-60485f8e967f",
      "itemDescription":
          "Capacity: 7Kg   ,Color: Black    ,Features: Full automatic, 7 kg capacity, silver color. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0225.jpg?alt=media&token=fb5bb490-97ae-48e1-83f4-60485f8e967f",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "8092.5",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "SHARP ES-FP914CXE-S Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0228.jpg?alt=media&token=b70cf5db-0e80-4d8a-a90a-6e2b5970ed28",
      "itemDescription":
          "Capacity: 9Kg   ,Color:  Dark Silver   ,Features: Full automatic, 9 kg capacity, silver color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0228.jpg?alt=media&token=b70cf5db-0e80-4d8a-a90a-6e2b5970ed28",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "10000",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "SHARP ES-TD13GBKP Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "itemDescription":
          "Capacity: 13Kg   ,Color:  Stainless Steel    ,Features: Inverter, pump, 13 kg capacity, black color. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "18499",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "SHARP ES-TD17GSSP Top Loading",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "itemDescription":
          "Capacity: 17Kg   ,Color: Black   ,Features: Inverter, pump, 17 kg capacity, stainless steel color. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "24973.2",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "LG F4R3TYGCP",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 8Kg   ,Features: Steam Wash, Inverter Direct Drive, 6 Motion DD, Smart Diagnosis, Silver color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "27499",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "LG F4R3TYG6J",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "itemDescription":
          "Capacity: 8Kg   ,Features: Inverter Direct Drive, 6 Motion DD, Smart Diagnosis, Middle Black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "25999",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "LG F4Y5RYGYPV",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 10Kg  ,Features: Inverter Direct Drive, 6 Motion DD, Smart Diagnosis, Silver color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "29499",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "LG F4Y5RYGYJV",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "itemDescription":
          "Capacity: 10Kg  ,Features: Inverter Direct Drive, 6 Motion DD, Smart Diagnosis, Dark Grey color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "29999",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "LG T1364NEHGB",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0244.jpg?alt=media&token=54b32680-55d3-4bb9-9ee1-5a073f1e6f6d",
      "itemDescription":
          "Capacity: 13Kg  ,Features: Smart Inverter, Turbo Drum, Auto Restart, Black color. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0244.jpg?alt=media&token=54b32680-55d3-4bb9-9ee1-5a073f1e6f6d",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "16199",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "LG T1388NEHGB",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0207.jpg?alt=media&token=d9b6bd42-3360-4618-8377-9a15a4cb24b0",
      "itemDescription":
          "Capacity: 13Kg  ,Features: Smart Inverter, Turbo Drum, Auto Restart, Middle Black color. ",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0207.jpg?alt=media&token=d9b6bd42-3360-4618-8377-9a15a4cb24b0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "17250",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "LG T1164NEHGB",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "itemDescription":
          "Capacity: 11Kg  ,Features: Smart Inverter, Turbo Drum, Auto Restart, Black color. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "14490",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "7",
    },
    {
      "itemName": "ZANUSSI ZWF6240SS5",
      "brandName": "ZANUSSI",
      "brandId": "zEpLSe7m5yEk9NUCPzDS",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "itemDescription":
          "Capacity: 6Kg  ,Spin Speed:1200 rpm ,color: Silver ,Features: PerlaMax, 12 washing programs, anti-flood protection, anti-foam rinse system. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "15299",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "ZANUSSI ZWF7221DL7",
      "brandName": "ZANUSSI",
      "brandId": "zEpLSe7m5yEk9NUCPzDS",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 7Kg   ,Spin Speed:1200 rpm ,color: Dark Grey ,Features: SteamMax, inverter motor, 12 washing programs, anti-flood protection. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22479",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "ZANUSSI ZWF7240SB5",
      "brandName": "ZANUSSI",
      "brandId": "zEpLSe7m5yEk9NUCPzDS",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "itemDescription":
          "Capacity: 7Kg   ,Spin Speed:1200 rpm ,color: Silver ,Features: PerlaMax, 12 washing programs, anti-flood protection, anti-foam rinse system. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0219.jpg?alt=media&token=c333eb60-37bf-42b7-8333-cf55425833b5",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "16999",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "ZANUSSI ZWF8221DL7",
      "brandName": "ZANUSSI",
      "brandId": "zEpLSe7m5yEk9NUCPzDS",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "itemDescription":
          "Capacity: 8Kg   ,Spin Speed:1200 rpm ,color: Dark Grey ,Features: SteamMax, inverter motor, 12 washing programs, anti-flood protection. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22999",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "ZANUSSI ZWF8240SB5",
      "brandName": "ZANUSSI",
      "brandId": "zEpLSe7m5yEk9NUCPzDS",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "itemDescription":
          "Capacity: 8Kg   ,Spin Speed:1200 rpm ,color: Silver ,Features: PerlaMax, 12 washing programs, anti-flood protection, anti-foam rinse system. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "18499",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "7",
    },
    {
      "itemName": "AKAI WMMA-SFL84VBS Front Load",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "itemDescription":
          "Capacity: 8Kg   ,Dimensions (mm): 51 (H) x 59.5 (W) x 51 (D) ,color: Silver ,Features: Front load design, 8 kg capacity, energy-efficient, multiple wash programs.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "5999",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "9",
    },
    {
      "itemName": "AKAI WMMA-XTL73S Top Load",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "itemDescription":
          "Capacity: 8Kg    ,Dimensions (mm): 85 (H) x 58 (W) x 55 (D) ,color: White ,Features: Top load design, 7 kg capacity, fully automatic, multiple wash programs. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "7499",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "8",
    },
    {
      "itemName": "AKAI WMMA-X015TT Twin Tub Semi-Automatic",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 8Kg    ,Dimensions (mm): 89 (H) x 52.5 (W) x 104.5 (D) ,color: Silver Grey  ,Features: Twin tub design, 14 kg capacity, semi-automatic, separate wash and spin tubs.",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "4500",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "9",
    },
    {
      "itemName": "AKAI WMMA-X020TT Twin Tub Semi-Automatic",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "itemDescription":
          "Capacity: 8Kg    ,Dimensions (mm): 1015 (H) x 600 (W) x 1120 (D) ,color: White ,Features: Twin tub design, 20 kg capacity, powerful pulsator, suitable for large households. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "5000",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "PERFIX Fola 6K",
      "brandName": "PERFIX",
      "brandId": "4RdiJpZmAPJADVnDafBA",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "itemDescription":
          "Capacity: 8Kg   ,color: White ,Features: Compact design, suitable for small households, basic washing functions. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22990",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "PERFIX Panda",
      "brandName": "PERFIX",
      "brandId": "4RdiJpZmAPJADVnDafBA",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 8Kg   ,color: White ,Features: Portable design, ideal for apartments, simple controls. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "18500",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "Samsung WW80T534DAN1AS Front Load",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 8Kg   ,Spin Speed:1400 rpm ,color: Black ,Features: Eco Bubble™ Technology, AI Control, Auto Dispense, Wi-Fi Connectivity. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22399",
      "rate": "5",
      "stock": "1",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "6",
    },
    {
      "itemName": "Samsung WW70T4020CX1AS Front Load",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "itemDescription":
          "Capacity: 7Kg   ,Spin Speed:1200 rpm ,color: Inox ,Features: Digital Inverter Motor, Hygiene Steam Cycle, Smart Control. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0229.jpg?alt=media&token=b8c25b6a-5e5d-48a0-80cf-b7cea58949b8",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "17777",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "Samsung WA11DG5410BDAS Top Load",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 11Kg   ,Spin Speed:700 rpm ,color: Gray ,Features: Digital Inverter Motor, Wobble Technology, Smart Control. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "14549",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "Samsung WA19CG6886BVAS Top Load",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "itemDescription":
          "Capacity: 19Kg   ,Spin Speed:700 rpm ,color: Black ,Features: Digital Inverter Motor, Eco Bubble™, Smart Control. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0208.jpg?alt=media&token=cc160ff3-5b6e-43cf-8f27-40b85bc4ea8e",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "25543",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "Samsung WW90T4040CX1 Front Load",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "itemDescription":
          "Capacity: 9Kg   ,Spin Speed:1400 rpm ,color: Inox ,Features: Hygiene Steam Cycle, Digital Inverter Motor, Smart Control. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0231.jpg?alt=media&token=2df5f299-7d57-4235-8f94-ceda895f5b10",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22388",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "1",
    },
    {
      "itemName": "Samsung WW80CGC0EDABAS Front Load",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 8Kg   ,Spin Speed:1400 rpm ,color: Black ,Features: Hygiene Steam Cycle, Digital Inverter Motor, Smart Control. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "26000",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "Samsung WD21T6300GV/AS Washer-Dryer Combo",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "itemDescription":
          "Capacity: 12Kg(wash), 12Kg (Dry)  ,Spin Speed:1400 rpm ,color: Black ,Features: Eco Bubble™, AI Control, Auto Dispense, Wi-Fi Connectivity.  ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "53002",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "0",
    },
    {
      "itemName": "WHITE POINT WPTL 9 DG",
      "brandName": "WHITE POINT",
      "brandId": "lAPd9wnpnKFSKXXjYOJ2",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 9Kg  ,color:Silver ,Features: Automatic washing machine with multiple wash programs.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "9499",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "1",
    },
    {
      "itemName": "WHITE POINT WPTL 15 DG",
      "brandName": "WHITE POINT",
      "brandId": "lAPd9wnpnKFSKXXjYOJ2",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "itemDescription":
          "Capacity: 15Kg  ,color: Grey ,Features: Automatic washing machine with digital display and multiple wash programs.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0235.jpg?alt=media&token=1b42eb5e-9d32-4ebb-a3e8-0b74e3d0d8bd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "19999",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "5",
    },
    {
      "itemName": "WHITE POINT WPW71015DSWS",
      "brandName": "WHITE POINT",
      "brandId": "lAPd9wnpnKFSKXXjYOJ2",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "itemDescription":
          "Capacity: 7Kg  ,color:Silver ,Features: Full automatic washing machine with inverter motor and steam wash.",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0241.jpg?alt=media&token=fd8a5423-f3e7-4fe2-91b2-4ccc6ebb3ba0",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "15999",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "2",
    },
    {
      "itemName": "WHITE POINT WPTL 18 DG",
      "brandName": "WHITE POINT",
      "brandId": "lAPd9wnpnKFSKXXjYOJ2",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "itemDescription":
          "Capacity: 18Kg  ,color: Café ,Features: Automatic washing machine with digital display and multiple wash programs.",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0242.jpg?alt=media&token=1ef037c2-0228-452d-a18d-ae809fea3683",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "22000",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "3",
    },
    {
      "itemName": "WHITE POINT WPW9121TSSWVSG-SL",
      "brandName": "WHITE POINT",
      "brandId": "lAPd9wnpnKFSKXXjYOJ2",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "itemDescription":
          "Capacity: 9Kg  ,color:Silver ,Features: Full automatic washing machine with touch screen, inverter motor, and steam wash.",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0243.jpg?alt=media&token=90a1da46-278a-4088-8349-5ac2428437fd",
      "idSubCategory": "ZGYbkw3w8truqvOFhtLA",
      "supCategory": "Washing machine",
      "price": "21899",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FTake%20the%20thinking%20out%20of%20washing%20%E2%80%93%20Samsung%E2%80%99s%20Bespoke%20Smart%20Laundry%20range%20is%20coming!.mp4?alt=media&token=0e2fbb77-f773-48de-b105-ee985769ac06",
      "itemSell": "4",
    },
    {
      "itemName": "Sharp SJ-GV58A(BK) Top Mount",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0227.jpg?alt=media&token=9dfca2eb-96e9-497a-b759-fa044323a972",
      "itemDescription":
          "Capacity: 450 Liters ,color: Black ,Features: Inverter technology, No Frost, energy-efficient, spacious compartments.",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0227.jpg?alt=media&token=9dfca2eb-96e9-497a-b759-fa044323a972",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "34999",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "Sharp SJ-48C(SL) Top Mount",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0187.jpg?alt=media&token=6431c02b-371d-48e1-ae29-0cabb9898475",
      "itemDescription":
          "Capacity: 385 Liters  ,color: Silver ,Features: No Frost, energy-efficient, sleek design, adjustable shelves.",
      "discount": "9",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0187.jpg?alt=media&token=6431c02b-371d-48e1-ae29-0cabb9898475",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "26022",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "0",
    },
    {
      "itemName": "Sharp SJ-PV63G-DST Bottom Freezer",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0175.jpg?alt=media&token=f2427b25-02ff-4a2d-a71f-f08154256d7e",
      "itemDescription":
          "Capacity: 480 Liters  ,color: Dark Stainless Steel ,Features: Inverter Digital, No Frost, bottom freezer design, modern aesthetics.",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0175.jpg?alt=media&token=f2427b25-02ff-4a2d-a71f-f08154256d7e",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "39059",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "0",
    },
    {
      "itemName": "Sharp SJ-PV73K-BK Bottom Freezer",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0177.jpg?alt=media&token=f88db42f-734d-481f-a338-1b18a29d6058",
      "itemDescription":
          "Capacity: 558 Liters  ,color: Black ,Features: Inverter Digital, No Frost, bottom freezer design, large capacity.",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0177.jpg?alt=media&token=f88db42f-734d-481f-a338-1b18a29d6058",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "53025",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "Sharp SJ-GV48G-SL Top Mount",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0211.jpg?alt=media&token=9dfdca1e-a378-40e5-a3bd-024182f5202f",
      "itemDescription":
          "Capacity: 396 Liters  ,color: Silver ,Features: Inverter, No Frost, energy-efficient, spacious compartments.",
      "discount": "9",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0211.jpg?alt=media&token=9dfdca1e-a378-40e5-a3bd-024182f5202f",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "28199",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "Sharp SJ-GV69G-RD Bottom Freezer",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0189.jpg?alt=media&token=4d4a1dd1-68c0-44b2-836b-cd5f7015ae0a",
      "itemDescription":
          "Capacity: 538 Liters  ,color: Red ,Features: Inverter Digital, No Frost, bottom freezer design, modern aesthetics.",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0189.jpg?alt=media&token=4d4a1dd1-68c0-44b2-836b-cd5f7015ae0a",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "50460",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "0",
    },
    {
      "itemName": "Sharp SJ-GV58G-SL Top Mount",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 450 Liters  ,color: Silver ,Features: Inverter Digital, No Frost, energy-efficient, spacious compartments.",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "38199",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "8",
    },
    {
      "itemName": "Sharp SJ-GV48G-RD Top Mount",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 385 Liters  ,color: Red ,Features: Inverter, No Frost, energy-efficient, sleek design.",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "28655",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "0",
    },
    {
      "itemName": "Sharp SJ-GV69G-BK Bottom Freezer",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 538 Liters  ,color: Black ,Features: Inverter Digital, No Frost, bottom freezer design, modern aesthetics.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "50360",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Sharp SJ-PV48G-BK Top Mount",
      "brandName": "Sharp",
      "brandId": "teUu5rNEsCAPdMmnN88G",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "itemDescription": "",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "27955",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO RF-40FT-SL",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 355 Liters  ,Dimensions (mm): 66.5 x 70.4 x 160.3 cm  ,Features: No Frost, Active Plasma Filter, Mobile Ice Maker, Energy Efficiency Class A, 10-year warranty. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "22000",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "3",
    },
    {
      "itemName": "TORNADO RF-480AT-SL",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0199.jpg?alt=media&token=8503ec74-7205-4c52-a03e-d052b82a5ae8",
      "itemDescription":
          "Capacity: 386 Liters  ,Dimensions (mm):64.5 x 68 x 167 cm  ,Features: No Frost, Ag+ Nano Deodorizer Filter, Hybrid Cooling System, Automatic Disconnection System, Door Open Alarm, Internal LED Lighting, Energy Efficiency Class A, 10-year warranty. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0199.jpg?alt=media&token=8503ec74-7205-4c52-a03e-d052b82a5ae8",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "24000",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "0",
    },
    {
      "itemName": "TORNADO RF-31FT-BK",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "itemDescription":
          "Capacity: 296 Liters  ,Dimensions (mm): 60.4 x 70.4 x 150.1 cm  ,Features: No Frost, Active Plasma Filter, Mobile Ice Maker, Energy Efficiency Class A, 10-year warranty. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "20000",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "TORNADO RF-480T-DST",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0197.jpg?alt=media&token=e73e4192-c17b-4cd7-84c7-0144cfb3481c",
      "itemDescription":
          "Capacity: 386 Liters  ,Dimensions (mm): 64.5 x 68 x 167 cm  ,Features: No Frost, Ag+ Nano Deodorizer Filter, Hybrid Cooling System, Automatic Disconnection System, Door Open Alarm, Internal LED Lighting, Energy Efficiency Class A, 10-year warranty. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0197.jpg?alt=media&token=e73e4192-c17b-4cd7-84c7-0144cfb3481c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "24000",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "TORNADO RF-51FTV-SL",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 395 Liters  ,Dimensions (mm): 71.7 x 68 x 177 cm  ,Features: Inverter No Frost, Energy Efficiency Class A, 10-year warranty. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "30500",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "8",
    },
    {
      "itemName": "TORNADO RF-58T-ST",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0176.jpg?alt=media&token=f116a9af-d448-4220-8712-5f6da22914dc",
      "itemDescription":
          "Capacity: 450 Liters  ,Dimensions (mm): Not specified  ,Features: No Frost, Digital Control, Energy Efficiency Class A, 10-year warranty. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0176.jpg?alt=media&token=f116a9af-d448-4220-8712-5f6da22914dc",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "32499",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "8",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 13 Feet, Defrost, 2 Door, 320 Liters, Black",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0211.jpg?alt=media&token=9dfdca1e-a378-40e5-a3bd-024182f5202f",
      "itemDescription":
          "Capacity: 320 Liters  ,Dimensions (mm): Not specified  ,Features: Defrost system, 2 doors, black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0211.jpg?alt=media&token=9dfdca1e-a378-40e5-a3bd-024182f5202f",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "11999",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "7",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 14 Feet, Defrost, 2 Door, 350 Liters, Black",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0189.jpg?alt=media&token=4d4a1dd1-68c0-44b2-836b-cd5f7015ae0a",
      "itemDescription":
          "Capacity: 350 Liters  ,Dimensions (mm): Not specified  ,Features: Defrost system, 2 doors, black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0189.jpg?alt=media&token=4d4a1dd1-68c0-44b2-836b-cd5f7015ae0a",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "13099",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Unionaire Digital Refrigerator, 16 Feet, 380 Liters, Black",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 380 Liters  ,Dimensions (mm): Not specified  ,Features: Digital controls, black color. ",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "14199",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 14 Feet, No Frost, 2 Doors, 350 Liters, Black",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 350 Liters  ,Dimensions (mm): Not specified  ,Features: No Frost system, 2 doors, black color. ",
      "discount": "20",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "16999",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 16 Feet, No Frost, 2 Doors, 370 Liters, Black",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 370 Liters  ,Dimensions (mm): Not specified  ,Features:No Frost system, 2 doors, black color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "20499",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "1",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 22 Feet, No Frost, 545 Liters, Black Glass",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "itemDescription":
          "Capacity: 545 Liters  ,Dimensions (mm): Not specified  ,Features: No Frost system, 2 doors, black glass finish. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "24350",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 16 Feet, No Frost, 2 Doors, 370 Liters, Stainless",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 370 Liters  ,Dimensions (mm): Not specified  ,Features: No Frost system, 2 doors, stainless steel finish. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "17999",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName":
          "Unionaire Refrigerator, 11 Feet, Defrost, 1 Door, 300 Liters, Silver",
      "brandName": "UNIONAIRE",
      "brandId": "T9isTyZXBzUZ4HQVPSpk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 300 Liters  ,Dimensions (mm): Not specified  ,Features: Defrost system, 1 door, silver color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "3599",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Fresh FNT-MR470 YGQBM",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0189.jpg?alt=media&token=4d4a1dd1-68c0-44b2-836b-cd5f7015ae0a",
      "itemDescription":
          "Capacity: 397 Liters  ,color: Black , Dimensions (mm): Digital control panel, smart Bluetooth connectivity. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0189.jpg?alt=media&token=4d4a1dd1-68c0-44b2-836b-cd5f7015ae0a",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "26888",
      "rate": "5",
      "stock": "1",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "Fresh FNT-M470 YT",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 397 Liters  ,color: Stainless ,Dimensions (mm): LED lighting, adjustable shelves, energy-efficient design. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "21999",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "7",
    },
    {
      "itemName": "Fresh FNT-BR400BS",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 336 Liters  ,color: Silver ,Dimensions (mm): No Frost technology, 14 feet capacity, sleek design. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "19999",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "3",
    },
    {
      "itemName": "Fresh FNT-D540YT",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 426 Liters  ,color: Stainless ,Dimensions (mm): Digital top mount freezer, energy-efficient, spacious compartments. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "25000",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "Fresh FDD-B315BS",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 294 Liters  ,color: Silver ,Dimensions (mm): De-Frost refrigerator, 12 feet capacity, compact design. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "14999",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "ALASKA UP 270",
      "brandName": "ALASKA",
      "brandId": "6dCIIqqoLQt5Di6TPDQO",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 300 Liters  ,color: White ,Dimensions (mm): Not specified  ,Features: Single door, defrost, adjustable shelves. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "13340",
      "rate": "5",
      "stock": "3",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "ALASKA HD 520",
      "brandName": "ALASKA",
      "brandId": "6dCIIqqoLQt5Di6TPDQO",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 300 Liters ,color: Stainless  ,Dimensions (mm): 1710 x 696 x 685 mm  ,Features: No-frost, multi air-flow, fashionable handles. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "27725",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "ALASKA KGT 2",
      "brandName": "ALASKA",
      "brandId": "6dCIIqqoLQt5Di6TPDQO",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "itemDescription":
          "Capacity: 300 Liters  ,color: Stainless ,Dimensions (mm): Not specified  ,Features: Two doors, freezer on top. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "18515",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "ALASKA KGT 1",
      "brandName": "ALASKA",
      "brandId": "6dCIIqqoLQt5Di6TPDQO",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 300 Liters  ,color: Stainless ,Dimensions (mm): Not specified  ,Features: Two doors, freezer on top. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "16560",
      "rate": "5",
      "stock": "20",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "ALASKA KS 27",
      "brandName": "ALASKA",
      "brandId": "6dCIIqqoLQt5Di6TPDQO",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 300 Liters  ,color: Silver ,Dimensions (mm): 1490 x 600 x 650 mm  ,Features: Single door, defrost, adjustable shelves. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "13705",
      "rate": "5",
      "stock": "30",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "HAMBURG FB15",
      "brandName": "HAMBURG",
      "brandId": "3YHYhjsYfwMqsOxzzRIk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 140 Liters  ,color: Silver ,Dimensions (mm): 81 x 54 x 55 cm ,Features: Mini bar refrigerator, automatic defrost, portable, suitable for small spaces.",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "6950",
      "rate": "5",
      "stock": "52",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "HAMBURG FB30-S",
      "brandName": "HAMBURG",
      "brandId": "3YHYhjsYfwMqsOxzzRIk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0199.jpg?alt=media&token=8503ec74-7205-4c52-a03e-d052b82a5ae8",
      "itemDescription":
          "Capacity: 300 Liters  ,color: Silver ,Dimensions (mm): Not specified  ,Features: Two-door refrigerator, defrost, suitable for medium-sized families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0199.jpg?alt=media&token=8503ec74-7205-4c52-a03e-d052b82a5ae8",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "17499",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "HAMBURG FB32-W",
      "brandName": "HAMBURG",
      "brandId": "3YHYhjsYfwMqsOxzzRIk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "itemDescription":
          "Capacity: 300 Liters  ,color: White ,Dimensions (mm): 169 x 59.5 x 54 cm  ,Features: Top freezer fridge, defrost, energy-efficient, quiet operation, 5-year warranty. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "9145",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "HAMBURG FB32-SLV",
      "brandName": "HAMBURG",
      "brandId": "3YHYhjsYfwMqsOxzzRIk",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0197.jpg?alt=media&token=e73e4192-c17b-4cd7-84c7-0144cfb3481c",
      "itemDescription":
          "Capacity: 320 Liters  ,color: Silver ,Dimensions (mm): 166 x 60 x 62 cm ,Features: Deluxe two-door refrigerator, defrost, spacious interior, suitable for larger families. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0197.jpg?alt=media&token=e73e4192-c17b-4cd7-84c7-0144cfb3481c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "13226",
      "rate": "5",
      "stock": "20",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Samsung RT62K7158SL/AE",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 850 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Twin Cooling Plus, Digital Inverter Compressor, 20-year warranty.  ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "120000",
      "rate": "5",
      "stock": "30",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Samsung RT35K5100S8/MR",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 377 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: All-Around Cooling, Digital Inverter Compressor. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "9599",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Samsung RB34A6B0E41/MR",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 344 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: SpaceMax Technology, All-Around Cooling. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "10000",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "1",
    },
    {
      "itemName": "Samsung RS66A8100B1/MR",
      "brandName": "Samsung",
      "brandId": "EUHseogTmkovLpFayn7z",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "itemDescription":
          "Capacity: 632 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Twin Cooling Plus, SpaceMax Technology, Digital Inverter Compressor. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "96999",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "LG GC-B22FTLVB",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs6",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 530 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Smart Inverter Linear Compressor, Smart ThinQ, Pure N Fresh, No Frost, Door Cooling+. ",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "96999",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "LG GN-H622HLHL",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs7",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 474 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "51999",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "LG GN-H722HLHL",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs8",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 506 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "66000",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "LG GC-FB507PQAM",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs9",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 519 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "90000",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "7",
    },
    {
      "itemName": "LG GTF402SSAN",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs10",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 401 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Digital Inverter Compressor, No Frost, Door Cooling+, Hygiene Fresh. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "77923",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "3",
    },
    {
      "itemName": "LG GN-F702HLHU",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs11",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 509 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "80000",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "LG GN-F722HLHL",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs12",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "itemDescription":
          "Capacity: 546 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "75000",
      "rate": "5",
      "stock": "20",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "LG GN-H722HFHL",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs13",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 506 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "80000",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "9",
    },
    {
      "itemName": "LG GN-B472PLGB",
      "brandName": "LG",
      "brandId": "CPh7zHcXwhMEzL5b3vs14",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 472 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Linear Compressor, No Frost, Door Cooling+, Hygiene Fresh, Smart ThinQ. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "50000",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "WHITE WHALE WR-4385 HBX",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 430 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2-door design, No Frost technology, black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "24999",
      "rate": "5",
      "stock": "26",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "WHITE WHALE WR-4385 HSS",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 430 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features:2-door design, No Frost technology, stainless steel color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "23499",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "WHITE WHALE WR-5395 HBX",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "itemDescription":
          "Capacity: 540 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2-door Inverter refrigerator, No Frost technology, black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "37371",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "WHITE WHALE WR-6395 HB",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 640 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Digital 2-door refrigerator, black color. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "64999",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "WHITE WHALE WR-9320AB INV",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 610 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Side-by-side Inverter Digital 2-door refrigerator, black color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "78845",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "4",
    },
    {
      "itemName": "WHITE WHALE WR-9399AB-INV",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 540 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Digital 4-door refrigerator with dispenser, black color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "100695",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "WHITE WHALE WR-7399AB INV",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 435 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Digital 4-door refrigerator with dispenser, black color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "70295",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "WHITE WHALE WR-6399AB INV",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 415 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter Digital 4-door refrigerator, black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "60795",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "3",
    },
    {
      "itemName": "WHITE WHALE WR-3375 HSS",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 340 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Freestanding refrigerator, No Frost technology, silver color. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "16499",
      "rate": "5",
      "stock": "4",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "WHITE WHALE WR-4385 HSSX",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "itemDescription":
          "Capacity: 430 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2-door refrigerator with water dispenser, stainless steel color. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0167.jpg?alt=media&token=78709468-2052-4f11-ba30-73706a32261c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "22950",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "1",
    },
    {
      "itemName": "WHITE WHALE WR-H4K SS",
      "brandName": "WHITE WHALE",
      "brandId": "qttjnQvjY6264PgdGqqJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 90 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Defrost Mini Bar refrigerator, stainless steel color. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "6900",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "1",
    },
    {
      "itemName": "Toshiba GR-RT559WE-DMN(49) No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 411 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter technology, 2 doors, gray color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "26999",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "Toshiba GR-RT468WE-DMN(49) No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "itemDescription":
          "Capacity: 338 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter technology, 2 doors, light gray color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0172.jpg?alt=media&token=da36e7f1-54d6-4a3e-9e4a-148ab4acd5df",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "19999",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "Toshiba GR-RT702WE-PMN(02) No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 535 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: Inverter technology, 2 doors, stainless steel appearance. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "34899",
      "rate": "5",
      "stock": "13",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "Toshiba GR-EF51Z-FS Inverter",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "itemDescription":
          "Capacity: 419 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2 doors, silver color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0226.jpg?alt=media&token=58b2ca44-a9a9-4635-b1e2-f0a306a6e3ed",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "29699",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "2",
    },
    {
      "itemName": "Toshiba GR-EF40P-J-SL No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 355 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2 doors, silver color.",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "23350",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "Toshiba GR-EF37-J-SL No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "itemDescription":
          "Capacity: 350 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2 doors, silver color.",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0210.jpg?alt=media&token=facf2b0b-f7da-4fa5-b8c7-4ec8ad934a9c",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "21708",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "5",
    },
    {
      "itemName": "Toshiba GR-EF33-T-SL No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "itemDescription":
          "Capacity: 304 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2 doors, silver color.",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0194.jpg?alt=media&token=44f53b6a-4d91-4791-9cbb-ccab98fdbeaf",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "19515",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Toshiba GR-EF40P-R-SL No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "itemDescription":
          "Capacity: 355 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2 doors, silver color.",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0230.jpg?alt=media&token=42f627b3-7da0-4808-92a5-c9779de57f65",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "23000",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "Toshiba GR-EF40P-T-S No Frost",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "itemDescription":
          "Capacity: 355 Liters  ,color: Silver ,Dimensions (mm):  Not specified  ,Features: 2 doors, silver color.",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0215.jpg?alt=media&token=21ec0551-a649-4144-b20e-8daf953166e3",
      "idSubCategory": "Y8NBskWxIfswW1dxPjwx",
      "supCategory": "Refrigerator",
      "price": "26599",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2F%D9%83%D9%8A%D9%81%20%D9%8A%D8%B9%D9%85%D9%84%20%D8%A7%D9%84%D8%A8%D8%B1%D8%A7%D8%AF%20(%D8%A7%D9%84%D8%AB%D9%84%D8%A7%D8%AC%D8%A9)%20%D8%A8%D8%A7%D9%84%D8%AA%D9%81%D8%B5%D9%8A%D9%84%20__%20Refrigerator%203D%20Animation.mp4?alt=media&token=e5cb08d2-3455-473d-992b-ec69ea198ff0",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO TVC-160SP Canister",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0154.jpg?alt=media&token=9165779a-49e8-49dd-8edb-f1db98267644",
      "itemDescription":
          "Power:  1600W  ,Filter Type: Antibacterial  ,color: Black ,Features: Antibacterial filter, 3.5L capacity, 5-meter cord, 2.5-meter hose, 3 accessories. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0154.jpg?alt=media&token=9165779a-49e8-49dd-8edb-f1db98267644",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3514",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "5",
    },
    {
      "itemName": "TORNADO TVC-160SG Canister",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0192.jpg?alt=media&token=ce7ec961-a7a5-4f9a-9306-cfabe4d7ee4d",
      "itemDescription":
          "Power:  1600W  ,Filter Type: Antibacterial  ,color: Grey/Black ,Features: Antibacterial filter, 3.5L capacity, 5-meter cord, 2.5-meter hose, 3 accessories. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0192.jpg?alt=media&token=ce7ec961-a7a5-4f9a-9306-cfabe4d7ee4d",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3840",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "7",
    },
    {
      "itemName": "TORNADO TVC-1600MG Canister",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0214.jpg?alt=media&token=2977c551-f5b4-455d-a333-8abbed44bb29",
      "itemDescription":
          "Power:  1600W  ,Filter Type: HEPA ,color: Black/Grey ,Features: HEPA filter, 3.5L capacity, 5-meter cord, 2.5-meter hose, 3 accessories. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0214.jpg?alt=media&token=2977c551-f5b4-455d-a333-8abbed44bb29",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3399",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "6",
    },
    {
      "itemName": "TORNADO TVC-1600MD Canister",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0196.jpg?alt=media&token=5f290c25-a357-4491-af34-dc06cda508d0",
      "itemDescription":
          "Power:  1600W  ,Filter Type: HEPA  ,color: Black/Maroon ,Features: HEPA filter, 3.5L capacity, 5-meter cord, 2.5-meter hose, 3 accessories. ",
      "discount": "32",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0196.jpg?alt=media&token=5f290c25-a357-4491-af34-dc06cda508d0",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3553",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "4",
    },
    {
      "itemName": "TORNADO TVC-180SG Canister",
      "brandName": "TORNADO",
      "brandId": "lDVn3fZxUjSMHJUYouqp",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0236.jpg?alt=media&token=c4e0e8e9-c685-46e0-b746-5a2b5fc8171c",
      "itemDescription":
          "Power:  1800W  ,Filter Type: Antibacterial  ,color: Grey ,Features: Antibacterial filter, 3.5L capacity, 5-meter cord, 2.5-meter hose, 3 accessories. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0236.jpg?alt=media&token=c4e0e8e9-c685-46e0-b746-5a2b5fc8171c",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "4100",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "8",
    },
    {
      "itemName": "PERFIX El-Dababa Drum Vacuum Cleaner",
      "brandName": "PERFIX",
      "brandId": "4RdiJpZmAPJADVnDafBA",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0180.jpg?alt=media&token=826df1d3-80fc-4cb8-9593-071db46c1dca",
      "itemDescription":
          "Power:  2200W  ,Container Capacity: 20L  ,color: Black and Silver ,Features: Bagless design, high suction power, suitable for large areas. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0180.jpg?alt=media&token=826df1d3-80fc-4cb8-9593-071db46c1dca",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3908.19",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "1",
    },
    {
      "itemName": "PERFIX El-Dababa Drum Vacuum Cleaner",
      "brandName": "PERFIX",
      "brandId": "4RdiJpZmAPJADVnDafBA",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0171.jpg?alt=media&token=a534b1ba-e898-47ff-ae58-eb67e32e0923",
      "itemDescription":
          "Power:  2200W  ,Container Capacity: 20L  ,color: Silver and Black ,Features: Bagless design, high suction power, suitable for large areas. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0171.jpg?alt=media&token=a534b1ba-e898-47ff-ae58-eb67e32e0923",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3908.19",
      "rate": "5",
      "stock": "13",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "22",
    },
    {
      "itemName": "PERFIX Tank Vacuum Cleaner",
      "brandName": "PERFIX",
      "brandId": "4RdiJpZmAPJADVnDafBA",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0149.jpg?alt=media&token=ae0acd07-fe2a-4afa-8fa9-c14c3ec578cd",
      "itemDescription":
          "Power:  2200W  ,Container Capacity: 20L  ,color: Red ,Features: Bagless design, high suction power, suitable for large areas. ",
      "discount": "6",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0149.jpg?alt=media&token=ae0acd07-fe2a-4afa-8fa9-c14c3ec578cd",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "3485",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "2",
    },
    {
      "itemName": "KENWOOD VC7050",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0160.jpg?alt=media&token=1ec27858-413d-4c40-b1c6-e7b140d592e3",
      "itemDescription":
          "Power:  2200W  ,Container Capacity: 2.5L ,color: Black ,Features: Bagless design, dust indicator, automatic cord storage, includes furniture and fabric tools. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0160.jpg?alt=media&token=1ec27858-413d-4c40-b1c6-e7b140d592e3",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "8799",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "0",
    },
    {
      "itemName": "KENWOOD VBP80",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0154.jpg?alt=media&token=9165779a-49e8-49dd-8edb-f1db98267644",
      "itemDescription":
          "Power:  2200W  ,Container Capacity:3.5L  ,color: Black/Red ,Features: Bagless design, multi-surface cleaning, includes crevice and upholstery tools. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0154.jpg?alt=media&token=9165779a-49e8-49dd-8edb-f1db98267644",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "5899",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "0",
    },
    {
      "itemName": "KENWOOD VC2786R",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0192.jpg?alt=media&token=ce7ec961-a7a5-4f9a-9306-cfabe4d7ee4d",
      "itemDescription":
          "Power:  2400W  ,Container Capacity: 3L  ,color: Red,Features: Digital vacuum cleaner, HEPA filter, metal adjustable arm, suitable for home and office use. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0192.jpg?alt=media&token=ce7ec961-a7a5-4f9a-9306-cfabe4d7ee4d",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "7195",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "0",
    },
    {
      "itemName": "Toshiba VC-EA100",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0214.jpg?alt=media&token=2977c551-f5b4-455d-a333-8abbed44bb29",
      "itemDescription":
          "Power:  1600W  ,Dust Bag Capacity:4.5L  ,color: Red/Blue ,Features: Normal filter, 5-meter power cord. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0214.jpg?alt=media&token=2977c551-f5b4-455d-a333-8abbed44bb29",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "1775",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "12",
    },
    {
      "itemName": "Toshiba VC-EA1600SE",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0196.jpg?alt=media&token=5f290c25-a357-4491-af34-dc06cda508d0",
      "itemDescription":
          "Power:  1600W  ,Dust Bag Capacity:4.5L  ,color: Red/Black ,Features: Dusting brush included. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0196.jpg?alt=media&token=5f290c25-a357-4491-af34-dc06cda508d0",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "4300",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "12",
    },
    {
      "itemName": "Toshiba VC-EA1800SE",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0236.jpg?alt=media&token=c4e0e8e9-c685-46e0-b746-5a2b5fc8171c",
      "itemDescription":
          "Power:  1800W  ,Dust Bag Capacity:4.5L  ,color: Red/Black ,Features: Dusting brush included. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0236.jpg?alt=media&token=c4e0e8e9-c685-46e0-b746-5a2b5fc8171c",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "4400",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "14",
    },
    {
      "itemName": "Toshiba VC-EA300",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0180.jpg?alt=media&token=826df1d3-80fc-4cb8-9593-071db46c1dca",
      "itemDescription":
          "Power:  2500W  ,Dust Bag Capacity:4.5L  ,color: Red ,Features: High suction power. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0180.jpg?alt=media&token=826df1d3-80fc-4cb8-9593-071db46c1dca",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "7799",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "13",
    },
    {
      "itemName": "Toshiba VCEA210",
      "brandName": "Toshiba",
      "brandId": "d5uDiC0UoyxfQCf0NO8p",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0171.jpg?alt=media&token=a534b1ba-e898-47ff-ae58-eb67e32e0923",
      "itemDescription":
          "Power:  1800W  ,Dust Bag Capacity:2.5L   ,color: Red ,Features: Automatic reel type. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0171.jpg?alt=media&token=a534b1ba-e898-47ff-ae58-eb67e32e0923",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "2500",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "16",
    },
    {
      "itemName": "Fresh Vacuum Cleaner Max 2200W",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0149.jpg?alt=media&token=ae0acd07-fe2a-4afa-8fa9-c14c3ec578cd",
      "itemDescription":
          "Power:  2200W  ,Container Capacity: 5L  ,color: Silver ,Features: Washable HEPA filter, thermal cut-off, low noise, sponge filter, includes brush for carpets and floors. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0149.jpg?alt=media&token=ae0acd07-fe2a-4afa-8fa9-c14c3ec578cd",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "4465",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "10",
    },
    {
      "itemName": "Fresh Vacuum Cleaner Faster 1600W",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0160.jpg?alt=media&token=1ec27858-413d-4c40-b1c6-e7b140d592e3",
      "itemDescription":
          "Power:  1600W  ,Container Capacity: 3.5L ,color: Red ,Features: HEPA filter, telescopic pipe, electrical dust full indicator, 5m power cord. ",
      "discount": "8",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0160.jpg?alt=media&token=1ec27858-413d-4c40-b1c6-e7b140d592e3",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "2830",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "12",
    },
    {
      "itemName": "Fresh Vacuum Cleaner Max 2200W",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0154.jpg?alt=media&token=9165779a-49e8-49dd-8edb-f1db98267644",
      "itemDescription":
          "Power:  2200W  ,Container Capacity: 5L  ,color: Silver ,Features: Washable HEPA filter, thermal cut-off, low noise, sponge filter, includes brush for carpets and floors. ",
      "discount": "9",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0154.jpg?alt=media&token=9165779a-49e8-49dd-8edb-f1db98267644",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "4465",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "12",
    },
    {
      "itemName": "AKAI AK-2000",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0192.jpg?alt=media&token=ce7ec961-a7a5-4f9a-9306-cfabe4d7ee4d",
      "itemDescription":
          "Power:  2000W  ,Container Capacity: 5.5L ,color: Red ,Features: Bagless design, long metal telescopic stick, 360-degree rotating hose, washable dust bag. ",
      "discount": "4",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0192.jpg?alt=media&token=ce7ec961-a7a5-4f9a-9306-cfabe4d7ee4d",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "2599",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "10",
    },
    {
      "itemName": "AKAI AKC2000R",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0214.jpg?alt=media&token=2977c551-f5b4-455d-a333-8abbed44bb29",
      "itemDescription":
          "Power:  2000W  ,Container Capacity: 20L  ,color: Red ,Features: High efficiency, parking position for easy use, space-saving dust container. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0214.jpg?alt=media&token=2977c551-f5b4-455d-a333-8abbed44bb29",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "2480",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "5",
    },
    {
      "itemName": "AKAI AK-1800",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0196.jpg?alt=media&token=5f290c25-a357-4491-af34-dc06cda508d0",
      "itemDescription":
          "Power:  1800W  ,Container Capacity: 3.5L  ,color: Red ,Features: Anti-bacterial filter, suitable for various cleaning tasks. ",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0196.jpg?alt=media&token=5f290c25-a357-4491-af34-dc06cda508d0",
      "idSubCategory": "Miyjmo7X8AaOUFO1bYEd",
      "supCategory": "Vacuum cleaner",
      "price": "2850",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2Fvideoplayback.mp4?alt=media&token=17d538a6-af1d-4ffc-b7d5-bbc21f312af6",
      "itemSell": "8",
    },
    {
      "itemName": "IHOME KI-5000",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0150.jpg?alt=media&token=a5996101-9af0-43ff-92ae-634506327226",
      "itemDescription":
          "Capacity: 40 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Thermostat, 90-minute timer, black color. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0150.jpg?alt=media&token=a5996101-9af0-43ff-92ae-634506327226",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1669.5",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "9",
    },
    {
      "itemName": "IHOME KI-5100",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.58_daf96caa.jpg?alt=media&token=4b0b4c7a-949c-4561-b3b3-1cf1b72a71e6",
      "itemDescription":
          "Capacity: 40 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Grill function, thermostat, 90-minute timer, black color. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.58_daf96caa.jpg?alt=media&token=4b0b4c7a-949c-4561-b3b3-1cf1b72a71e6",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1404",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "10",
    },
    {
      "itemName": "IHOME KI-5125",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0153.jpg?alt=media&token=4ca14c4d-67ec-4562-a857-476556958345",
      "itemDescription":
          "Capacity: 40 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Timer up to 90 minutes, thermostat, black color. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0153.jpg?alt=media&token=4ca14c4d-67ec-4562-a857-476556958345",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "2200",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "2",
    },
    {
      "itemName": "IHOME KI-7000",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0186.jpg?alt=media&token=7c8cc80a-1571-4a52-9727-f096abcd972b",
      "itemDescription":
          "Capacity: 45 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Thermostat, black color. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0186.jpg?alt=media&token=7c8cc80a-1571-4a52-9727-f096abcd972b",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1149",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "0",
    },
    {
      "itemName": "IHOME KI-7100",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0166.jpg?alt=media&token=387c209d-4848-47d5-9b0a-c7dd49dacbe7",
      "itemDescription":
          "Capacity: 45 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Grill function, 90-minute timer, thermostat, black color. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0166.jpg?alt=media&token=387c209d-4848-47d5-9b0a-c7dd49dacbe7",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1399",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "IHOME KI-7125",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0120.jpg?alt=media&token=4d7a76d6-9c00-4454-b0be-8b96724e7b07",
      "itemDescription":
          "Capacity: 45 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: 90-minute timer, thermostat, black color. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0120.jpg?alt=media&token=4d7a76d6-9c00-4454-b0be-8b96724e7b07",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1399",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "IHOME 25L Digital",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0191.jpg?alt=media&token=4edf57f5-fca4-49c4-9c30-1ff12ba7c4d7",
      "itemDescription":
          "Capacity: 25 Liters,Power:  N/A ,Container Capacity: 3.5L  ,color: Red ,Features: Normally black digital microwave. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0191.jpg?alt=media&token=4edf57f5-fca4-49c4-9c30-1ff12ba7c4d7",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "5699",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "IHOME 20L Virgin",
      "brandName": "IHOME",
      "brandId": "wMuyikoeOEXjwacTOb2X",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0206.jpg?alt=media&token=1638dae3-869f-4837-942f-1cd9ba3898e2",
      "itemDescription":
          "Capacity: 20 Liters,Power:  N/A  ,Container Capacity: 3.5L  ,color: Red ,Features: Black microwave. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0206.jpg?alt=media&token=1638dae3-869f-4837-942f-1cd9ba3898e2",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "4599",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "AKAI AK-10",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0135.jpg?alt=media&token=68c37265-bc3e-48fd-af18-6751a9db45d5",
      "itemDescription":
          "Capacity: 25 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Digital screen, 10 power levels, defrost by time and weight, multi-step cooking, quick start.",
      "discount": "8",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0135.jpg?alt=media&token=68c37265-bc3e-48fd-af18-6751a9db45d5",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "4900",
      "rate": "5",
      "stock": "10",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "AKAI AK-20",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0126.jpg?alt=media&token=b4c29d0c-4edb-4984-bb31-d1c3bb49b783",
      "itemDescription":
          "Capacity: 30 Liters,Power:  1200W  ,Container Capacity: 3.5L  ,color: Red ,Features: Digital screen, 10 power levels, defrost by time and weight, multi-step cooking, quick start.",
      "discount": "9",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0126.jpg?alt=media&token=b4c29d0c-4edb-4984-bb31-d1c3bb49b783",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "5390",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "5",
    },
    {
      "itemName": "AKAI MW064A-823MS/MW073A",
      "brandName": "AKAI",
      "brandId": "Tcny94cQt6AGFIGt5N7b",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0125.jpg?alt=media&token=379c6286-11ee-4fc2-bf6f-77d2908c05f7",
      "itemDescription":
          "Capacity: 20 Liters,Power:  1000W  ,Container Capacity: 3.5L  ,color: Red ,Features: Microwave with grill, 5 power levels, defrost function, 60-minute timer.",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0125.jpg?alt=media&token=379c6286-11ee-4fc2-bf6f-77d2908c05f7",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "2999",
      "rate": "5",
      "stock": "2",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "7",
    },
    {
      "itemName": "ATA MW25LG003",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.56_35b12148.jpg?alt=media&token=42f450d0-9ccd-4ace-ad30-cfe0328c1aa3",
      "itemDescription":
          "Capacity: 25 Liters,Power:  1400W ,Container Capacity: 3.5L  ,color: Red ,Features: Digital controls, 10 power levels, grill function, LED display. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.56_35b12148.jpg?alt=media&token=42f450d0-9ccd-4ace-ad30-cfe0328c1aa3",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "4700",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "6",
    },
    {
      "itemName": "ATA DIG25",
      "brandName": "ATA",
      "brandId": "vmCJF4Z8TeI3rJM08W8H",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0200.jpg?alt=media&token=cf86e459-09c0-4768-ae74-ce4cbe81d80c",
      "itemDescription":
          "Capacity: 25 Liters,Power:  900W  ,Container Capacity: 3.5L  ,color: Red ,Features: Digital controls, 5 power levels, defrost function. ",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0200.jpg?alt=media&token=cf86e459-09c0-4768-ae74-ce4cbe81d80c",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1699",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "8",
    },
    {
      "itemName": "KUMETAL Kumtel Microwave Oven 20L",
      "brandName": "KUMETAL",
      "brandId": "cOIvPAlo7tRmqzFnUPjb",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.56_61983285.jpg?alt=media&token=6a63ba75-f51f-4425-8658-701ce77f409a",
      "itemDescription":
          "Capacity: 20 Liters,Power:  700W  ,Container Capacity: 3.5L  ,color: Red ,Features: 2-in-1 microwave with grill, rotating turntable, time-controlled defrosting function. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.56_61983285.jpg?alt=media&token=6a63ba75-f51f-4425-8658-701ce77f409a",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1380",
      "rate": "5",
      "stock": "5",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "6",
    },
    {
      "itemName": "KUMETAL Kumtel Electric Oven LX5125",
      "brandName": "KUMETAL",
      "brandId": "cOIvPAlo7tRmqzFnUPjb",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0115.jpg?alt=media&token=b997fed3-f7e3-4743-8db9-20e37436c01d",
      "itemDescription":
          "Capacity: 52 Liters,Power:  2000W  ,Container Capacity: 3.5L  ,color: Red ,Features: Large capacity, multiple cooking functions, adjustable temperature control. ",
      "discount": "2",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0115.jpg?alt=media&token=b997fed3-f7e3-4743-8db9-20e37436c01d",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "6000",
      "rate": "5",
      "stock": "6",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "4",
    },
    {
      "itemName": "KUMETAL Kumtel Microwave Digital 20L Black",
      "brandName": "KUMETAL",
      "brandId": "cOIvPAlo7tRmqzFnUPjb",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0155.jpg?alt=media&token=d97d2ffa-ed4e-4ca6-a868-3a89e886130c",
      "itemDescription":
          "Capacity: 20 Liters,Power:  700W ,Container Capacity: 3.5L  ,color: Red ,Features: Digital controls, multiple power levels, defrost function. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0155.jpg?alt=media&token=d97d2ffa-ed4e-4ca6-a868-3a89e886130c",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "1500",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "9",
    },
    {
      "itemName": "ELARABY Tornado TM-25MS",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0202.jpg?alt=media&token=e9b0217b-8690-487c-aa25-0d794265eda6",
      "itemDescription":
          "Capacity: 25 Liters,Power:  900W  ,Container Capacity: 3.5L  ,color: Red ,Features: 900 Watt, Silver Color, 8 Menus, Solo Function. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0202.jpg?alt=media&token=e9b0217b-8690-487c-aa25-0d794265eda6",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "6998.98",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "12",
    },
    {
      "itemName": "ELARABY Tornado MOM-C25BBE-S",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0205.jpg?alt=media&token=29e87a08-9ff3-4592-a251-ee1093c8a485",
      "itemDescription":
          "Capacity: 25 Liters,Power:  900W  ,Container Capacity: 3.5L  ,color: Red ,Features: 900 Watt, Silver Color, 10 Menus, Grill Function. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0205.jpg?alt=media&token=29e87a08-9ff3-4592-a251-ee1093c8a485",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "6527.8",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "22",
    },
    {
      "itemName": "ELARABY Tornado MOM-C36BBE-BK",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0182.jpg?alt=media&token=f91d2149-4b6e-466b-b4c8-8aaefc71ca1a",
      "itemDescription":
          "Capacity: 36 Liters,Power:  1000W  ,Container Capacity: 3.5L  ,color: Red ,Features: 1000 Watt, Black Color, 8 Menus, Grill Function. ",
      "discount": "7",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0182.jpg?alt=media&token=f91d2149-4b6e-466b-b4c8-8aaefc71ca1a",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "6999",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "22",
    },
    {
      "itemName": "ELARABY Sharp R-75MT(S)",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0203.jpg?alt=media&token=c549df9e-b0ed-4c1f-bee6-bb81273e22e9",
      "itemDescription":
          "Capacity: 25 Liters,Power:  900W  ,Container Capacity: 3.5L  ,color: Red ,Features: 900 Watt, Silver Color, 6 Menus, Grill Function. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0203.jpg?alt=media&token=c549df9e-b0ed-4c1f-bee6-bb81273e22e9",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "6349",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "33",
    },
    {
      "itemName": "ELARABY Sharp R-77AT-ST",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.55_af28daee.jpg?alt=media&token=21b294de-4a2c-4f73-b0ae-15c1b22682b2",
      "itemDescription":
          "Capacity: 34 Liters,Power:  1000W  ,Container Capacity: 3.5L  ,color: Red ,Features: 1000 Watt, Silver Color, 8 Menus, Microwave Function. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.55_af28daee.jpg?alt=media&token=21b294de-4a2c-4f73-b0ae-15c1b22682b2",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "7389",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "12",
    },
    {
      "itemName": "ELARABY Sharp R-750MR(K)",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.57_d3d78223.jpg?alt=media&token=866cd635-4240-49e8-a645-45ea257a23bd",
      "itemDescription":
          "Capacity: 25 Liters,Power:  900W  ,Container Capacity: 3.5L  ,color: Red ,Features: 900 Watt, Black Color, 6 Menus, Grill Function. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B5%D9%88%D8%B1%D8%A9%20%D9%88%D8%A7%D8%AA%D8%B3%D8%A7%D8%A8%20%D8%A8%D8%AA%D8%A7%D8%B1%D9%8A%D8%AE%201446-11-02%20%D9%81%D9%8A%2014.02.57_d3d78223.jpg?alt=media&token=866cd635-4240-49e8-a645-45ea257a23bd",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "3199",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "14",
    },
    {
      "itemName": "ELARABY Sharp R-770AR(ST)",
      "brandName": "ELARABY",
      "brandId": "6EDebRissJmZSuGtlEMJ",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0151.jpg?alt=media&token=efdd0ff0-d541-4b16-bfe3-004f4c83a263",
      "itemDescription":
          "Capacity: 34 Liters,Power:  1000W  ,Container Capacity: 3.5L  ,color: Red ,Features: 1000 Watt, Stainless Steel Color, 9 Menus, Grill Function. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0151.jpg?alt=media&token=efdd0ff0-d541-4b16-bfe3-004f4c83a263",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "10638",
      "rate": "5",
      "stock": "12",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "15",
    },
    {
      "itemName": "Fresh FMW-20MC-SM",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0072.jpg?alt=media&token=d85a2862-a4e6-465e-bdd9-fadaddfbd774",
      "itemDescription":
          "Capacity: 20 Liters,Power:  700W  ,Container Capacity: 3.5L  ,color: Red ,Features: Mirror finish, 700W power, mechanical control, 5 heating levels, 2-year warranty. ",
      "discount": "0",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0072.jpg?alt=media&token=d85a2862-a4e6-465e-bdd9-fadaddfbd774",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "4490",
      "rate": "5",
      "stock": "11",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "Fresh FMW-25KC-S",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0162.jpg?alt=media&token=abdc56ab-4f14-4ce1-a6d0-0bf44d26bf61",
      "itemDescription":
          "Capacity: 25 Liters,Power:  700W  ,Container Capacity: 3.5L  ,color: Red ,Features: Black color, mechanical control, 700W power, 5 heating levels, 2-year warranty. ",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0162.jpg?alt=media&token=abdc56ab-4f14-4ce1-a6d0-0bf44d26bf61",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "5700",
      "rate": "5",
      "stock": "14",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "2",
    },
    {
      "itemName": "Fresh FMW-36KCG-S",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0158.jpg?alt=media&token=31f8527e-af97-4a75-9117-4463c2405faf",
      "itemDescription":
          "Capacity: 36 Liters,Power:  1000W  ,Container Capacity: 3.5L  ,color: Red ,Features: Silver color, microwave and grill functions, 1000W power, digital control, 2-year warranty. ",
      "discount": "10",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0158.jpg?alt=media&token=31f8527e-af97-4a75-9117-4463c2405faf",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "8095",
      "rate": "5",
      "stock": "15",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "7",
    },
    {
      "itemName": "Fresh FMW-42KC-S",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0145.jpg?alt=media&token=ce7b413a-3730-40bd-a674-9be7222c5f26",
      "itemDescription":
          "Capacity: 42 Liters,Power:  1100W  ,Container Capacity: 3.5L  ,color: Red ,Features: Silver color, microwave and grill functions, 1100W power, digital control, 2-year warranty. ",
      "discount": "12",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0145.jpg?alt=media&token=ce7b413a-3730-40bd-a674-9be7222c5f26",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "8500",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "8",
    },
    {
      "itemName": "Fresh FR-4503RCL",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0074.jpg?alt=media&token=3581a756-f113-4812-88a8-c87f60790df1",
      "itemDescription":
          "Capacity: 45 Liters,Power:  2000W  ,Container Capacity: 3.5L  ,color: Red ,Features: Black color, 2000W power, grill and fan functions, mechanical control, 2-year warranty. ",
      "discount": "13",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0074.jpg?alt=media&token=3581a756-f113-4812-88a8-c87f60790df1",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "2200",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "9",
    },
    {
      "itemName": "Fresh FR-48OMEGA",
      "brandName": "Fresh",
      "brandId": "qv8OefRZajMBLiPU8GEd",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0085.jpg?alt=media&token=fa70a9aa-6dd2-4211-941e-2b8afb7ccd10",
      "itemDescription":
          "Capacity: 48 Liters,Power:  2850W  ,Container Capacity: 3.5L  ,color: Red ,Features: Black/Silver color, 2850W power, grill and fan functions, mechanical control, 2-year warranty. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0085.jpg?alt=media&token=fa70a9aa-6dd2-4211-941e-2b8afb7ccd10",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "2850",
      "rate": "5",
      "stock": "7",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "4",
    },
    {
      "itemName": "KENWOOD MWM42.000BK",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0195.jpg?alt=media&token=c8b9b538-5880-465a-baf8-a4cf2b201f5d",
      "itemDescription":
          "Capacity: 42 Liters,Power:  1100W  ,Container Capacity: 3.5L  ,color: Red ,Features: 1100W microwave, 1400W grill, digital display, 5 power levels, defrost function, stainless steel, clock function. ",
      "discount": "3",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0195.jpg?alt=media&token=c8b9b538-5880-465a-baf8-a4cf2b201f5d",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "12999",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "8",
    },
    {
      "itemName": "KENWOOD MWL426",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0118.jpg?alt=media&token=70e0b680-b158-4940-ac62-31c887831c6c",
      "itemDescription":
          "Capacity: 42 Liters,Power:  1800W  ,Container Capacity: 3.5L  ,color: Red ,Features: Built-in grill, electronic controls, 7 auto menu programs, 10 microwave power levels, easy-to-clean painted interior, child safety lock. ",
      "discount": "15",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0118.jpg?alt=media&token=70e0b680-b158-4940-ac62-31c887831c6c",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "9999",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "5",
    },
    {
      "itemName": "KENWOOD MOM45",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0142.jpg?alt=media&token=d09f3395-5d6d-4073-b390-94f54dbeac9e",
      "itemDescription":
          "Capacity: 45 Liters,Power:  1800W  ,Container Capacity: 3.5L  ,color: Red ,Features: Large capacity, double glass door, multifunctional with rotisserie and convection function for grilling, toasting, broiling, baking, defrosting. ",
      "discount": "14",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0142.jpg?alt=media&token=d09f3395-5d6d-4073-b390-94f54dbeac9e",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "25000",
      "rate": "5",
      "stock": "8",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "2",
    },
    {
      "itemName": "KENWOOD MOA26.600SS",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0073.jpg?alt=media&token=e41876f3-bccf-4aad-8a6b-20111ee0080d",
      "itemDescription":
          "Capacity: 25 Liters,Power:  700W  ,Container Capacity: 3.5L  ,color: Red ,Features: 2-in-1 functionality, large capacity, rotisserie function for frying, roasting, grilling, broiling, baking, browning, defrosting, heating. ",
      "discount": "16",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0073.jpg?alt=media&token=e41876f3-bccf-4aad-8a6b-20111ee0080d",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "11999",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "46",
    },
    {
      "itemName": "KENWOOD MWM30.000BK",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0182.jpg?alt=media&token=f91d2149-4b6e-466b-b4c8-8aaefc71ca1a",
      "itemDescription":
          "Capacity: 30 Liters,Power:  700W  ,Container Capacity: 3.5L  ,color: Red ,Features: 700W microwave, 700W grill, digital display, 8 power levels, defrost function, stainless steel. ",
      "discount": "1",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0182.jpg?alt=media&token=f91d2149-4b6e-466b-b4c8-8aaefc71ca1a",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "7495",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "1",
    },
    {
      "itemName": "KENWOOD MWM21.000WH",
      "brandName": "KENWOOD",
      "brandId": "S7XpKANjClhd2kG0Uk2d",
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0203.jpg?alt=media&token=c549df9e-b0ed-4c1f-bee6-bb81273e22e9",
      "itemDescription":
          "Capacity: 21 Liters,Power:  800W  ,Container Capacity: 3.5L  ,color: Red ,Features: 800W microwave, white color, digital display, 5 power levels, defrost function. ",
      "discount": "5",
      "imageIcon":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2FIMG-20250502-WA0203.jpg?alt=media&token=c549df9e-b0ed-4c1f-bee6-bb81273e22e9",
      "idSubCategory": "D0hsjud3bt7UgDQE6t4R",
      "supCategory": "MICROWAVES",
      "price": "4999",
      "rate": "5",
      "stock": "9",
      "videoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/video%2FOven%20animation%20__%203D%20Animation%20__%20Short%20video%20__%20Product%20Animation.mp4?alt=media&token=43003a96-5bc6-4d6d-90e3-22d74bddd515",
      "itemSell": "5",
    },
  ];
  printRandomProductData() async {
    List<ItemModel> items = [];
    final random = Random();
    final dataBrand = [
      BrandModel(
        brandName: "Miele",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FMiele.png?alt=media&token=e065ae7f-0f63-45a1-960a-56c74166a37d",
        BrandId: "0B2YsdJbbFv0Tnk2sP9j",
      ),
      BrandModel(
        brandName: "Hitachi",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FHitachi.png?alt=media&token=83ad545c-67da-4f58-a555-b53408fab4bc",
        BrandId: "2s8d0wgwZiCjkoXzvzEG",
      ),
      BrandModel(
        brandName: "Black+Decker",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FBlack%2BDecker.png?alt=media&token=f2413032-b054-4acd-a6b5-99dd8a1865f6",
        BrandId: "3JXXsI3yaWitjYoEhUtc",
      ),
      BrandModel(
        brandName: "Siemens",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FSiemens.png?alt=media&token=f46adf97-fedf-4eb4-a36a-b22d529f3548",
        BrandId: "42oN7kdjMe6kTDwe3UV8",
      ),
      BrandModel(
        brandName: "GE Appliances",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FGE%20Appliances.png?alt=media&token=461e9d7a-3342-46b2-a17f-b704eb2c94cf",
        BrandId: "7L9VCgFNC3dFovu8SktK",
      ),
      BrandModel(
        brandName: "Indesit",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FIndesit.png?alt=media&token=e46e1788-e258-43ff-89b0-f79ade904878",
        BrandId: "8aRfFfZZxs0HPM0a5U0m",
      ),
      BrandModel(
        brandName: "Braun",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FBraun.png?alt=media&token=be108081-8b84-4978-91a8-833b17b495af",
        BrandId: "9pZNX7Zfxcp6KX8mc5L3",
      ),
      BrandModel(
        brandName: "LG",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2Flg.png?alt=media&token=ce4bdfe7-d361-43b6-98cd-b664359c25bb",
        BrandId: "CPh7zHcXwhMEzL5b3vs6",
      ),
      BrandModel(
        brandName: "Fisher & Paykel",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FFisher%20%26%20Paykel.png?alt=media&token=0d174fc7-d055-465f-bd65-25e350c1d34f",
        BrandId: "CRZmiqgBwA38e3HlsFPx",
      ),
      BrandModel(
        brandName: "Frigidaire",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FFrigidaire.png?alt=media&token=ed58f789-e8a2-4242-ab36-348affe8cccc",
        BrandId: "CTe56m9owAcOtulJd8Yo",
      ),
      BrandModel(
        brandName: "Candy",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FCandy.png?alt=media&token=ad51a3b6-8816-4081-89bc-eaa0e6b50872",
        BrandId: "CfqUKlV2X7NQNPnO901s",
      ),
      BrandModel(
        brandName: "Tefal",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FTefal.png?alt=media&token=982e7ee5-62a9-4166-9ff5-aa5dfaa9fabb",
        BrandId: "CrUnDpM6UimR89CNQ0US",
      ),
      BrandModel(
        brandName: "Samsung",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2Fsamsung.png?alt=media&token=8353b03a-18a5-4bc2-b3b9-d2c1525c57e5",
        BrandId: "EUHseogTmkovLpFayn7z",
      ),
      BrandModel(
        brandName: "Daewoo",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FDaewoo.png?alt=media&token=c2a19c08-b717-491a-949a-b9cc3ec4e085",
        BrandId: "FYL4ozAGXO7cmTZxCJa3",
      ),
      BrandModel(
        brandName: "Whirlpool",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FWhirlpool.png?alt=media&token=95a21da1-9c6a-471d-b36e-0fca7c066497",
        BrandId: "ID2HG2iyJIAg7GeHdzyq",
      ),
      BrandModel(
        brandName: "Ariston",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FAriston.png?alt=media&token=f929f17d-801a-4f9d-bb90-db462571c6cb",
        BrandId: "Le1e8BYGaQQfyIEAbISD",
      ),
      BrandModel(
        brandName: "Oster",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FOster.png?alt=media&token=f090cff1-0d28-4236-881f-94fba1927739",
        BrandId: "OAhPJ2Dh4i5H0ZujRHCs",
      ),
      BrandModel(
        brandName: "Rowenta",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FRowenta.png?alt=media&token=fff8413b-4168-47a4-bbe8-fe31059fe19c",
        BrandId: "QMQNl93WRf2n5zDbB7xC",
      ),
      BrandModel(
        brandName: "Blomberg",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FBlomberg.png?alt=media&token=5cac4cc2-f8fd-435f-a031-0707ab272f08",
        BrandId: "RvKQlcVqCrfGfulIMOY8",
      ),
      BrandModel(
        brandName: "Krups",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FKrups.png?alt=media&token=cda0704b-9fd1-47a0-aa8a-06089af0b8ea",
        BrandId: "TJvtpFwTSkE5DlXEdOnM",
      ),
      BrandModel(
        brandName: "Philips",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FPhilips.png?alt=media&token=2e3935ea-d71e-4dcd-8fde-5d44d15531d2",
        BrandId: "ThQDco3as9unhPR2USfp",
      ),
      BrandModel(
        brandName: "De'Longhi",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FDe'Longhi.png?alt=media&token=10fedd21-81f9-42ca-b4dc-4f30263ccb4e",
        BrandId: "WlAEpSAiyWoUeXcp1lG3",
      ),
      BrandModel(
        brandName: "Russell Hobbs",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FRussell%20Hobbs.png?alt=media&token=a70fe98b-88e5-4170-9d2b-2d82d5c2277c",
        BrandId: "Z5IrwCYft7TfasnWiNrN",
      ),
      BrandModel(
        brandName: "Zanussi",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FZanussi.png?alt=media&token=cc2a152a-9cb8-45c9-9605-3a8553dfbd38",
        BrandId: "assoAPRwtMgGVc78ttKD",
      ),
      BrandModel(
        brandName: "Toshiba",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FToshiba.png?alt=media&token=2433618d-aa0c-4515-96fb-2d6e8b33521b",
        BrandId: "d5uDiC0UoyxfQCf0NO8p",
      ),
      BrandModel(
        brandName: "Electrolux",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FElectrolux.png?alt=media&token=66bbcb98-845b-4a5f-842f-bcaca5127540",
        BrandId: "eR2hoksxLp5a5dRe0uWd",
      ),
      BrandModel(
        brandName: "Gorenje",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FGorenje.png?alt=media&token=bedd38e6-af86-4bc5-83ae-d6de3ee2915b",
        BrandId: "fGkNk3Ej0cOWjtket21i",
      ),
      BrandModel(
        brandName: "Panasonic",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FPanasonic.png?alt=media&token=4e26ad9e-c671-4bcb-a8a8-9093315c753a",
        BrandId: "fJTHFhDlvVamaL1rkhiS",
      ),
      BrandModel(
        brandName: "Morphy Richards",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FMorphy%20Richards.png?alt=media&token=b587ff98-c846-47bd-bce6-94f0be838cc1",
        BrandId: "fcJKOcFRwvH5PsymM5W2",
      ),
      BrandModel(
        brandName: "Bosch",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FBosch.png?alt=media&token=1412b922-0aa2-4ad5-9b89-918d4b1138a1",
        BrandId: "iznC70rhbAnRJjQOsW6R",
      ),
      BrandModel(
        brandName: "Kenmore",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FKenmore.png?alt=media&token=9186c526-1d51-410f-83c7-3136e2787550",
        BrandId: "jrRIgBuAjfDyFnPhtRdL",
      ),
      BrandModel(
        brandName: "Hamilton Beach",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FHamilton%20Beach.png?alt=media&token=5a161c86-26eb-41bd-9327-45cb461a33e8",
        BrandId: "mA2i885OgbCtSfpqgv4M",
      ),
      BrandModel(
        brandName: "Fresh",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2Ffresh.png?alt=media&token=171f9600-de42-40b6-a3c8-d1d621d4ce81",
        BrandId: "qv8OefRZajMBLiPU8GEd",
      ),
      BrandModel(
        brandName: "KitchenAid",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FKitchenAid.png?alt=media&token=6265ce32-6c57-4ed7-b076-478487c72885",
        BrandId: "sDcXW7R97SgejDWZuwdW",
      ),
      BrandModel(
        brandName: "Sharp",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2Fsharp.png?alt=media&token=979e1d29-0d04-41a7-be44-2a6e117fde92",
        BrandId: "teUu5rNEsCAPdMmnN88G",
      ),
      BrandModel(
        brandName: "Breville",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FBreville.png?alt=media&token=2d285d0c-fe04-491b-8596-b15afd0152bd",
        BrandId: "vGfALFTQGKmjjGZCrvzM",
      ),
      BrandModel(
        brandName: "Smeg",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FSmeg.png?alt=media&token=3856823a-09a3-42f7-b80a-9a9fd876f7e0",
        BrandId: "vlM1SqEQhZPOpNvW6M0C",
      ),
      BrandModel(
        brandName: "Nespresso",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FNespresso.png?alt=media&token=0cc5ddd1-0eb0-4aad-9505-071461993743",
        BrandId: "w01T3ZgqaFAnQlKvoKop",
      ),
      BrandModel(
        brandName: "Cuisinart",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FCuisinart.png?alt=media&token=00c9fc62-ad37-486d-bbb9-2c28133e6140",
        BrandId: "w6uGJQ5UvjXlwkxVjnMH",
      ),
      BrandModel(
        brandName: "Beko",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20brands%2FBeko.png?alt=media&token=3e094988-e20c-4c15-b400-dfede25455aa",
        BrandId: "wJj2IHCk3pBKSuP7jNUN",
      ),
    ];
    final dataSubCategory = [
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D8%A7%D9%8A%D9%83%D8%B1%D9%88%D9%88%D9%8A%D9%81.png?alt=media&token=39eff40f-0821-4306-ba34-dda8f7d177d0",
        nameCategores: "Microwave",
        idSubCategores: "D0hsjud3bt7UgDQE6t4R",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D8%A7%D9%83%D9%8A%D9%86%D8%A9%20%D9%82%D9%87%D9%88%D8%A9.png?alt=media&token=e2865213-af2d-4874-979a-6233de8bb1bc",
        nameCategores: "Coffee maker",
        idSubCategores: "Dtd9k01dsGHGYXHJdC1P",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%A8%D9%88%D8%AA%D8%AC%D8%A7%D8%B2.png?alt=media&token=075f7d28-ae60-4ab3-a964-a2ee9a6083e6",
        nameCategores: "Stove",
        idSubCategores: "HjsELIhWzm0LdUer0Mad",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B4%D8%A7%D8%B4%D8%A9.png?alt=media&token=ff9ae59d-a387-494d-8ff8-8fe1e6b7566f",
        nameCategores: "Screen TV",
        idSubCategores: "ItzjVkjkOg5wLdWgbUSG",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D8%B1%D9%88%D8%AD%D8%A9%20%D8%B9%D9%85%D9%88%D8%AF.png?alt=media&token=7d06eb55-bf4f-46df-ad18-7242807536fc",
        nameCategores: "Stand fan",
        idSubCategores: "KUBUS0UGfXVQBu62JLBZ",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D9%83%D9%86%D8%B3%D8%A9%20%D9%83%D9%87%D8%B1%D8%A8%D8%A7%D8%A6%D9%8A%D8%A9.png?alt=media&token=9dee9a99-f48e-4558-b8cf-1c571a8ade35",
        nameCategores: "Vacuum cleaner",
        idSubCategores: "Miyjmo7X8AaOUFO1bYEd",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%AA%D9%83%D9%8A%D9%8A%D9%81.png?alt=media&token=5857f3aa-5e67-4ec4-a179-df436c54ec77",
        nameCategores: "Air conditioner",
        idSubCategores: "NoIlnpFmjWPXqlYWgNW5",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%B3%D9%8A%D8%B4%D9%88%D8%A7%D8%B1.png?alt=media&token=74510ebb-aa4d-4144-9d36-ef6976bb0d79",
        nameCategores: "Hair dryer",
        idSubCategores: "PJVMljYl3oonLEzhdsWp",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%AB%D9%84%D8%A7%D8%AC%D8%A9.png?alt=media&token=dee43e95-faef-4a99-846c-6769cc252939",
        nameCategores: "Refrigerator",
        idSubCategores: "Y8NBskWxIfswW1dxPjwx",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%BA%D8%B3%D8%A7%D9%84%D8%A92.png?alt=media&token=ecd1d008-8bde-44bc-a72c-44619baee188",
        nameCategores: "Washing machine",
        idSubCategores: "ZGYbkw3w8truqvOFhtLA",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D8%B1%D9%88%D8%AD%D8%A9%20%D8%AD%D8%A7%D8%A6%D8%B7.png?alt=media&token=824368ef-31a3-46bf-a7ae-7a22ebdcf5a5",
        nameCategores: "Wall fan",
        idSubCategores: "ZnfzESg7mJSlH2TFwqLf",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D9%83%D9%88%D8%A7%D8%A9%20%D8%B4%D8%B9%D8%B1.png?alt=media&token=2dc39317-f66e-41aa-8ea1-152a2132536c",
        nameCategores: "Hair straightener",
        idSubCategores: "i57VAkjVRRjkobu2ZwIg",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D8%AF%D9%8A%D8%A8%20%D9%81%D8%B1%D9%8A%D8%B2%D8%B1.png?alt=media&token=2f838c9d-7ade-4fbc-9f37-e88d8557d72a",
        nameCategores: "Deep freezer",
        idSubCategores: "ldkz8GHgb9iD246WoMNY",
      ),
      SubcategoryModel(
        imageSubCategores:
            "https://firebasestorage.googleapis.com/v0/b/chat-app-d86a7.appspot.com/o/images%20icon%2F%D9%85%D9%83%D9%88%D8%A7%D8%A9.png?alt=media&token=a25f87a8-044e-4a36-8f0c-85723bd3233a",
        nameCategores: "Iron",
        idSubCategores: "uf3kz6QTI3KgpvcTEBD1",
      ),
    ];

    for (var bra in data) {
      items.add(
        ItemModel(
          brandName: bra["brandName"].toString(),
          brandId: bra["brandId"].toString(),
          isMoreSale: random.nextBool(),
          imageUrl: bra["imageUrl"].toString(),
          itemDescription: bra["itemDescription"].toString(),
          itemName: bra["itemName"].toString(),
          discount: double.parse(("${bra["discount"] ?? 0}.0")),
          imageIcon: bra["imageIcon"].toString(),
          idSubCategory: bra["idSubCategory"].toString(),
          price: double.parse(bra["price"]!),
          rate: bra["rate"] ?? '0.0',
          stock: bra["stock"] ?? '0.0',
          supCategory: bra["supCategory"] ?? '',
          videoUrl: bra["videoUrl"] ?? '',
          dateAdd: DateTime.now().toIso8601String(),
          itemSell: int.parse(bra["itemSell"] ?? '0'),
        ),
      );
    }
    for (var element in items) {
      FirebaseFirestore.instance.collection("items").add(element.toFireStore());
    }

    print(dataBrand.length);
    print(dataSubCategory.length);
    print(items.length);
  }

  int selectedIndex = 0;
  load() {
    getSubCategores();
    getItems();
    getBrand();
  }

  Future<void> getUserData() async {
    String? id = await AppUsageService.getUserId();
    await users.doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        model = UserModel.fromFirestore(documentSnapshot);
      }
      print(documentSnapshot.exists);
    });
  }

  searchProductsByPartialName(String searchTerm) async {
    itemListSearch.clear();
    isLoadingSearch = true.obs;

    for (var ser in listItemAndFiltter) {
      if (ser.itemName.toLowerCase().substring(0, searchTerm.length) ==
          searchTerm.toLowerCase()) {
        print(ser.itemName.toLowerCase());
        print(itemListSearch.length);
        print(ser.discount);
        print(ser.itemId);
        print(ser.itemSell);
        itemListSearch.add(ser);
      }
    }
    isLoadingSearch = false.obs;
    update();
  }

  subOrBrand() {
    if (brand != null) {
      listItemAndFiltter = [];
      for (var item in listItem) {
        if (item.brandId == brand) {
          listItemAndFiltter.add(item);
        }
      }
      brand = null;
      Get.to(const ProductListScreen());
    } else if (sub != null) {
      listItemAndFiltter = [];
      for (var item in listItem) {
        if (item.supCategory == sub) {
          listItemAndFiltter.add(item);
        }
      }
      sub = null;
      Get.to(const ProductListScreen());
    }
  }

  sortProducts(sortType) {
    final sortedList = listItemAndFiltter; // Copy to avoid modifying original
    if (sortType != 'normal') {
      switch (sortType) {
        // case SortType.priceLowToHigh:
        //   sortedList.sort((a, b) => a.price!.compareTo(b.price));
        //   break;
        // case SortType.priceHighToLow:
        //   sortedList.sort((a, b) => b.price!.compareTo(a.price));
        // break;
        case SortType.oldestFirst:
          sortedList.sort((a, b) => b.dateAdd.compareTo(a.dateAdd));
          break;
        case SortType.newestFirst:
          sortedList.sort((a, b) => a.dateAdd.compareTo(b.dateAdd));
          break;
        case SortType.fromAToZ:
          sortedList.sort((a, b) => a.itemName.compareTo(b.itemName));
          break;
        case SortType.fromZToA:
          sortedList.sort((a, b) => b.itemName.compareTo(a.itemName));
          break;

        // case SortType.bestSelling:
        //   sortedList.sort((a, b) => b.salesCount.compareTo(a.salesCount));
        //   break;
        // case SortType.newestFirst:
        //   sortedList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        //   break;
        // case SortType.oldestFirst:
        //   sortedList.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
        //   break;
      }

      listItemAndFiltter = sortedList;
    } else {
      listItemAndFiltter = sortedList;
    }

    update();
  }

  filtterToType(String typing) {
    filtterListItem = [];

    if (typing == 'الكل') {
      listItemAndFiltter = listItem;
    } else {
      for (var item in listItem) {
        if (item.supCategory == typing) {
          filtterListItem.add(item);
        }
      }
      if (filtterListItem.isNotEmpty) {
        listItemAndFiltter = filtterListItem;
      }
    }
  }

  getSubCategores() async {
    selectTypeList = [
      const DropdownMenuItem<String>(
        value: 'الكل',
        child: Center(child: Text('الكل')),
      ),
    ];
    listSubCategoryes = [];
    QuerySnapshot subCategores =
        await FirebaseFirestore.instance.collection("subCategores").get();

    for (var subCategory in subCategores.docs) {
      var sub = SubcategoryModel.fromFirestore(subCategory);
      listSubCategoryes.add(sub);
      selectTypeList!.add(
        DropdownMenuItem<String>(
          value: sub.nameCategores,
          child: Center(child: Text(sub.nameCategores)),
        ),
      );
      print(subCategory.id);
      print(sub.nameCategores);
      print(subCategory);

      update();
    }
    // listBrands2.addAll(brads.docs);
    print("selectTypeList==${selectTypeList?.length}");
    print(listSubCategoryes.length);
  }

  getItems() async {
    ItemModel? itemTest;
    listItem = [];
    listItemOffer = [];
    QuerySnapshot items =
        await FirebaseFirestore.instance.collection("items").get();

    for (var item in items.docs) {
      itemTest = ItemModel.fromFirestore(item);
      itemTest.itemId = item.id;
      listItem.add(itemTest);
      if (itemTest.discount != '') {
        listItemOffer.add(itemTest);
      }

      print(item.id);
      print(item["brand_id"]);
      print(listItem[0]);

      update();
    }
    listItemAndFiltter = listItem;
    // listBrands2.addAll(brads.docs);
    print(listItem.length);
  }

  getBrand() async {
    BrandModel? brandTest;
    listBrands = [];
    listBrands2 = [];
    QuerySnapshot brads =
        await FirebaseFirestore.instance.collection('brads').get();

    for (var brand in brads.docs) {
      brandTest = BrandModel.fromFirestore(brand);
      brandTest.BrandId = brand.id;
      print(brand.id);

      listBrands.add(brandTest);
      update();
      print(listBrands[0]);
    }

    listBrands2.addAll(brads.docs);
    print(listBrands.length);
  }

  Future<List<ItemModel>> fetchProducts() async {
    try {
      await productDB.get().then((productsSnapshot) {
        for (var element in productsSnapshot.docs) {
          _products.insert(0, ItemModel.fromFirestore(element));
        }
      });
      update();
      return _products;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<BrandModel>> fetchBrand() async {
    if (await CheckInternet.checkInternet()) {
      OverlayLoadingProgress.start();
      print("Bearer ${await AppUsageService.getToken()}");
      try {
        await brandDB.get().then((productsSnapshot) {
          for (var element in productsSnapshot.docs) {
            _brands.insert(0, BrandModel.fromFirestore(element));
          }
        });
        update();
        OverlayLoadingProgress.stop();
        return _brands;
      } catch (error) {
        rethrow;
      }
    } else {
      OverlayLoadingProgress.stop();
      isLoadingGetAllBrand = false.obs;
      showCustomSnackBar('Check the internet connection'.tr, isError: true);
      return [];
    }
  }
}
