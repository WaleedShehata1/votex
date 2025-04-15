import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:votex/core/model/item_model.dart';

import '../../core/classes/app_usage_service.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/model/brand_model.dart';
import '../../core/model/subcategory_model.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../features/store/store_screen.dart';

abstract class HomeController extends GetxController {
  // getAllBrand();
}

class HomeControllerImp extends HomeController {
  Rx<BrandModel>? brandModel;
  var isLoadingGetAllBrand = false.obs;
  String? brand;
  String? sub;
  @override
  void onInit() {
    load();
    fetchBrand();
    super.onInit();
  }

  int selectedIndex = 0;
  load() {
    getSubCategores();
    getItems();
    getBrand();
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectType;
  List<DropdownMenuItem<Object>>? selectTypeList;
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

  List<SubcategoryModel> listSubCategoryes = [];

  // List<QueryDocumentSnapshot> listBrands2 = [];
  List<ItemModel> filtterListItem = [];
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
        child: Center(
            child: Text(
          'الكل',
        )),
      )
    ];
    listSubCategoryes = [];
    QuerySnapshot subCategores =
        await FirebaseFirestore.instance.collection("subCategores").get();

    for (var subCategory in subCategores.docs) {
      var sub = SubcategoryModel.fromFirestore(subCategory);
      listSubCategoryes.add(sub);
      selectTypeList!.add(DropdownMenuItem<String>(
        value: sub.nameCategores,
        child: Center(child: Text(sub.nameCategores)),
      ));
      print(subCategory.id);
      print(sub.nameCategores);
      print(subCategory);

      update();
    }
    // listBrands2.addAll(brads.docs);
    print("selectTypeList==${selectTypeList?.length}");
    print(listSubCategoryes.length);
  }

  List<ItemModel> listItem = [];
  List<ItemModel> listItemAndFiltter = [];
  List<ItemModel> listItemOffer = [];
  // List<QueryDocumentSnapshot> listBrands2 = [];
  getItems() async {
    listItem = [];
    listItemOffer = [];
    QuerySnapshot items =
        await FirebaseFirestore.instance.collection("items").get();

    for (var item in items.docs) {
      listItem.add(ItemModel.fromFirestore(item));
      if (item["discount"] != '' || item["discount"] != null) {
        listItemOffer.add(ItemModel.fromFirestore(item));
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

  List<BrandModel> listBrands = [];
  List<QueryDocumentSnapshot> listBrands2 = [];
  getBrand() async {
    listBrands = [];
    listBrands2 = [];
    QuerySnapshot brads =
        await FirebaseFirestore.instance.collection('brads').get();

    for (var brand in brads.docs) {
      print(brand.id);

      listBrands.add(BrandModel.fromFirestore(brand));
      update();
      print(listBrands[0]);
    }

    listBrands2.addAll(brads.docs);
    print(listBrands.length);
  }

  final List<ItemModel> _products = [];
  List<ItemModel> get getProducts {
    return _products;
  }

  final List<BrandModel> _brands = [];
  List<BrandModel> get getBrande {
    return _brands;
  }

  final productDB = FirebaseFirestore.instance.collection("items");
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

  final brandDB = FirebaseFirestore.instance.collection("brads");
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
