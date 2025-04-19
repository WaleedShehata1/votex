import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/model/item_model.dart';
import '../../core/model/order_model.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../features/cart/cart_screen.dart';

abstract class CartController extends GetxController {
  // getAllBrand();
}

class CartControllerImp extends CartController {
  CollectionReference bills = FirebaseFirestore.instance.collection('Bills');
  final List<ItemModel> cartItems = [];
  double subtotal = 0.0;
  double deliveryFee = 0.0;
  String deliveryTime = '';
  double totalCost = 0.0;
  double sensorCost = 0.0;
  double itemsCount = 0.0;

  call(sensorPrice) {
    sensorCost = sensorPrice;
    subtotal = 0;
    if (cartItems.isNotEmpty) {
      for (int i = 0; i < cartItems.length; i++) {
        itemsCount = itemsCount + cartItems[i].count;
        subtotal =
            subtotal + (cartItems[i].count * cartItems[i].price) + sensorCost;
      }
      totalCost = subtotal + deliveryFee;
    } else {
      totalCost = sensorCost + deliveryFee;
    }

    update();
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
  }

  createOrder({address, phoneNumber}) async {
    String? id = await AppUsageService.getUserId();
    // List<DetiliesOrderModel> detiliesModel = [];
    OrderModel model = OrderModel(
        address: address,
        state: 'new',
        deliveryCost: deliveryFee.toString(),
        deliveryTime: deliveryTime,
        itemCount: itemsCount.toString(),
        payment: 'visa',
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
      print("order == ${value.id}");
      update();
    }).catchError((error) {
      showCustomSnackBar("order == $error", isError: true);
    });
  }
}
