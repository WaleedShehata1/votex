import 'package:get/get.dart';

import '../core/constants/images.dart';
import '../core/model/item_model.dart';
import '../core/widget/custom_snackbar.dart';

abstract class CartController extends GetxController {
  // getAllBrand();
}

class CartControllerImp extends CartController {
  final List<ItemModel> cartItems = [];
  double subtotal = 0.0;
  double deliveryFee = 60.20;
  double totalCost = 0.0;
  double sensorCost = 0.0;

  call(sensorPrice) {
    for (int i = 0; i < cartItems.length; i++) {
      subtotal =
          subtotal + (cartItems[i].count * cartItems[i].price) + sensorPrice;
    }
    totalCost = subtotal + deliveryFee;
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

  removed(ItemModel item) {
    cartItems.remove(item);
    showCustomSnackBar("Product removed".tr, isError: false);
  }
}
