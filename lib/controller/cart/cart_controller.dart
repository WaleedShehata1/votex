import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/model/item_model.dart';
import '../../core/model/order_model.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../features/cart/cart_screen.dart';
import '../account/account_controller.dart';
import 'package:intl/intl.dart';

abstract class CartController extends GetxController {
  // getAllBrand();
}

class CartControllerImp extends CartController {
  late TextEditingController address;
  late TextEditingController address2;
  late TextEditingController address3;
  late TextEditingController cardNumber;
  late TextEditingController cardName;
  late TextEditingController cardExp;
  late TextEditingController cvv;
  final AccountControllerImp accountControllerImp = Get.put(
    AccountControllerImp(),
  );
  CollectionReference bills = FirebaseFirestore.instance.collection('Bills');
  final List<ItemModel> cartItems = [];
  double subtotal = 0.0;
  double deliveryFee = 0.0;
  String deliveryTime = '';
  double totalCost = 0.0;
  double sensorCost = 0.0;
  int sensorcount = 0;
  double sensorprice = 0.0;
  double itemsCount = 0.0;
  @override
  void onInit() {
    address = TextEditingController();
    address2 = TextEditingController();
    address3 = TextEditingController();
    cardNumber = TextEditingController();
    cardName = TextEditingController();
    cardExp = TextEditingController();
    cvv = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    address.dispose();
    address2.dispose();
    address3.dispose();
    cardNumber.dispose();
    cardName.dispose();
    cardExp.dispose();
    cvv.dispose();
    cartController.call();
    super.dispose();
  }

  call() {
    sensorCost = sensorprice * sensorcount;
    subtotal = 0;
    if (cartItems.isNotEmpty && sensorprice != 0) {
      for (int i = 0; i < cartItems.length; i++) {
        itemsCount = itemsCount + cartItems[i].count;
        subtotal =
            subtotal + (cartItems[i].count * cartItems[i].price) + sensorCost;
      }
      totalCost = subtotal + deliveryFee;
    } else if (cartItems.isNotEmpty) {
      for (int i = 0; i < cartItems.length; i++) {
        itemsCount = itemsCount + cartItems[i].count;
        subtotal = subtotal + (cartItems[i].count * cartItems[i].price);
      }
      totalCost = subtotal + deliveryFee;
    } else {
      totalCost = sensorCost + deliveryFee;
    }
  }

  Future<void> getVisa() async {
    bool isVisa = false;
    bool isCost = false;
    QuerySnapshot visa =
        await FirebaseFirestore.instance.collection("visa").get();
    String? id = await AppUsageService.getUserId();
    for (var element in visa.docs) {
      if (element.id == cardNumber.text) {
        isVisa = true;
        if (double.parse(element['cost']) >= totalCost) {
          isCost = true;
        }
      }
    }
    if (isVisa) {
      if (isCost) {
        createOrder(
            address: accountControllerImp.address.text,
            phoneNumber: accountControllerImp.phoneNumber.text);
        Get.toNamed(RouteHelper.homePage);
      } else {
        showCustomSnackBar(
          "Insufficient balance".tr,
          isError: true,
        );
      }
    } else {
      showCustomSnackBar(
        "Visa data is incorrect".tr,
        isError: true,
      );
    }

    print("items==> ${visa.docs}");
    print("items==> $visa");
  }

  addItem(ItemModel item) {
    bool isAdd = false;
    for (int i = 0; i < cartItems.length; i++) {
      if (isAdd != true) {
        if (item.itemId == cartItems[i].itemId) {
          isAdd = true;
        }
      }
    }

    if (isAdd == false) {
      cartItems.add(item);
      print(cartItems.length);
      showCustomSnackBar("Product saved".tr, isError: false);
      cartController.call();
      print('adding');
    } else if (isAdd == true) {
      showCustomSnackBar(
        "The product has been added previously".tr,
        isError: false,
      );
      isAdd = false;
      print('is adding');
    }

    update();
  }

  addItemAndCart(ItemModel item) {
    bool isAdd = false;
    for (int i = 0; i < cartItems.length; i++) {
      if (isAdd != true) {
        if (item.itemId == cartItems[i].itemId) {
          isAdd = true;
        }
      }
    }

    if (isAdd == false) {
      cartItems.add(item);
      print(cartItems.length);
      Get.to(() => CartScreen());

      print('adding');
    } else if (isAdd == true) {
      showCustomSnackBar(
        "The product has been added previously".tr,
        isError: false,
      );
      isAdd = false;
      print('is adding');
    }

    update();
  }

  removed(ItemModel item) {
    cartItems.remove(item);
    showCustomSnackBar("Product removed".tr, isError: false);
    cartController.call();
    update();
  }

  createOrder({required String address, required String phoneNumber}) async {
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat(
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    ).format(now);
    String? id = await AppUsageService.getUserId();
    // List<DetiliesOrderModel> detiliesModel = [];
    OrderModel model = OrderModel(
        address: address,
        state: 'new',
        deliveryCost: deliveryFee.toString(),
        deliveryTime: deliveryTime,
        itemCount: itemsCount.toString(),
        payment: 'visa',
        dataAdd: formattedDate,
        totlePrice: totalCost.toString(),
        phoneNumber: phoneNumber,
        userId: id!);

    bills.add(model.toFireStore()).then((value) {
      if (cartItems.isNotEmpty) {
        for (var item in cartItems) {
          var totlePrice = item.discount != 0
              ? ((item.price * item.count) * (1 - (item.discount / 100)))
              : (item.price * item.count);
          DetiliesOrderModel detiliesModel = DetiliesOrderModel(
            discount: item.discount.toString(),
            idBills: value.id,
            idItem: item.itemId!,
            itemCount: item.count.toString(),
            itemPrice: item.price.toString(),
            nameItem: item.itemName,
            totlePrice: totlePrice.toString(),
          );
          bills
              .doc(value.id)
              .collection("Bills")
              .add(detiliesModel.toFireStore())
              .then((val) {})
              .catchError((error) {
            showCustomSnackBar("detiliesModel == $error", isError: true);
          });
        }
      }
      if (sensorCost != 0.0) {
        DetiliesOrderModel detiliesModel = DetiliesOrderModel(
          discount: '0',
          idBills: value.id,
          idItem: 'item.itemId',
          itemCount: 'item.count.toString()',
          itemPrice: 'item.price.toString()',
          nameItem: 'item.itemName',
          totlePrice: 'totlePrice.toString()',
        );
        bills
            .doc(value.id)
            .collection("Bills")
            .add(detiliesModel.toFireStore())
            .then((val) {})
            .catchError((error) {
          showCustomSnackBar("detiliesModel == $error", isError: true);
        });
      }
      cartItems.clear();
      update();
      showCustomSnackBar("The order has been requested", isError: false);
      print("order == ${value.id}");
    }).catchError((error) {
      showCustomSnackBar("order == $error", isError: true);
    });
  }
}
