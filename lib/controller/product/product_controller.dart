import 'package:get/get.dart';

import '../../core/constants/images.dart';

class ProductController extends GetxController {
  String image3D = Images.gasCooker3D;

  selectImage3D(String image) {
    switch (image) {
      case 'بوتجازات':
        image3D = Images.gasCooker3D;
        break;
      case 'ثلاجات':
        image3D = Images.refrigerator3D;
        break;
      case 'تكييفات':
        image3D = Images.conditioning3D;
        break;
      case 'ديب فريزر':
        image3D = Images.deepFreezer3D;
        break;
      case 'سيشوار':
        image3D = Images.blowDryer3D;
        break;
      case 'شاشة':
        image3D = Images.screen3D;
        break;
      case 'غسالة راسية':
        image3D = Images.washing3D;
        break;
      case 'ماكينة قهوة':
        image3D = Images.coffee3D;
        break;
      case 'مايكروويف':
        image3D = Images.microwave3D;
        break;
      case 'مرواحة حائط':
        image3D = Images.wallFan3D;
        break;
      case 'مرواحة عمود.':
        image3D = Images.pillarFan3D;
        break;
      case 'مكنسة كهربائية.':
        image3D = Images.vacuumCleaner3D;
        break;
      case 'مكواة شعر.':
        image3D = Images.hairStraightener3D;
        break;
      case 'مكواة':
        image3D = Images.iron3D;
        break;
    }
  }
}
