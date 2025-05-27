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
  var data = [];
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
        case SortType.priceLowToHigh:
          sortedList.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortType.priceHighToLow:
          sortedList.sort((a, b) => b.price.compareTo(a.price));
          break;
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
    print("items==${items.docs.length}");
    for (var item in items.docs) {
      itemTest = ItemModel.fromFirestore(item);
      itemTest.itemId = item.id;
      listItem.add(itemTest);
      if (itemTest.discount > 0) {
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
