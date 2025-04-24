import 'package:get/get.dart';

import '../../core/model/item_model.dart';
import '../../core/widget/custom_snackbar.dart';

abstract class SavedController extends GetxController {
  // getAllBrand();
}

class SavedControllerImp extends SavedController {
  final List<ItemModel> savedItems = [];

  addItem(ItemModel item) {
    bool isAdd = false;
    for (int i = 0; i < savedItems.length; i++) {
      if (isAdd != true) {
        if (item.itemId == savedItems[i].itemId) {
          isAdd = true;
        }
      }
    }
    if (isAdd == false) {
      savedItems.add(item);
      print(savedItems.length);
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
    savedItems.remove(item);
    showCustomSnackBar("Product removed".tr, isError: false);
    update();
  }
}
