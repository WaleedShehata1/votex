import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:votex/core/model/item_model.dart';

import '../../core/classes/app_usage_service.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/model/brand_model.dart';
import '../../core/widget/custom_snackbar.dart';

abstract class HomeController extends GetxController {
  // getAllBrand();
}

class HomeControllerImp extends HomeController {
  Rx<BrandModel>? brandModel;
  var isLoadingGetAllBrand = false.obs;
  @override
  void onInit() {
    fetchBrand();
    super.onInit();
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

  // @override
  // getAllBrand() async {
  //   if (await CheckInternet.checkInternet()) {
  //     print("Bearer ${await AppUsageService.getToken()}");
  //     try {
  //       isLoadingGetAllBrand = true.obs;
  //       brads.doc().get();

  //       print("get ${brads.doc().get().toString()}");
  //     } catch (e) {
  //       showCustomSnackBar(
  //         'An error occurred. Please try again.'.tr,
  //         isError: true,
  //       );
  //       // print('Error during get Main Categores: $e');
  //     } finally {
  //       isLoadingGetAllBrand = false.obs;
  //     }
  //   } else {
  //     isLoadingGetAllBrand = false.obs;
  //     showCustomSnackBar('Check the internet connection'.tr, isError: true);
  //   }
  // }
}
