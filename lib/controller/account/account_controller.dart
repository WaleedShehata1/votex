import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/classes/app_usage_service.dart';
import '../../core/model/user_model.dart';
import '../../core/widget/custom_snackbar.dart';

abstract class AccountController extends GetxController {}

class AccountControllerImp extends AccountController {
  late TextEditingController userName;
  late TextEditingController address;
  late TextEditingController phoneNumber;
  UserModel? model;

  final users = FirebaseFirestore.instance.collection('users');
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  void onInit() {
    userName = TextEditingController();
    address = TextEditingController();
    phoneNumber = TextEditingController();
    getUserData();
    super.onInit();
  }

  Future<void> getUserData() async {
    String? id = await AppUsageService.getUserId();
    await users.doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        model = UserModel.fromFirestore(documentSnapshot);
        userName.text = model!.userName;
        address.text = model!.address;
        phoneNumber.text = model!.phone;
      }
      print(documentSnapshot.exists);
    });
  }

  Future<void> getNotifications() async {
    String? id = await AppUsageService.getUserId();
    await users
        .doc(id)
        .collection('notifications')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> documentSnapshot) {
      // if (documentSnapshot.docs.isNotEmpty) {
      //   model = UserModel.fromFirestore(documentSnapshot);
      //   userName.text = model!.userName;
      //   address.text = model!.address;
      //   phoneNumber.text = model!.phone;
      // }
      // print(documentSnapshot.exists);
    });
  }

  Future<void> updateUserData() async {
    String? id = await AppUsageService.getUserId();
    if (formstate.currentState!.validate() && id != null) {
      return users
          .doc(id)
          .update({
            'phone': phoneNumber.text,
            'user_name': userName.text,
            'address': address.text,
          })
          .then(
              (value) => showCustomSnackBar("User Updated".tr, isError: false))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  @override
  void dispose() {
    userName.dispose();
    address.dispose();
    phoneNumber.dispose();
    super.dispose();
  }
}
