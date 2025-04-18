import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/model/contact_model.dart';
import '../../core/widget/custom_snackbar.dart';

class ContactController extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController userName;
  late TextEditingController email;
  late TextEditingController message;

  @override
  void onInit() {
    userName = TextEditingController();
    email = TextEditingController();
    message = TextEditingController();
    super.onInit();
  }

  Future<void> sendService() async {
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat(
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    ).format(now);

    print(formattedDate); // Example: 2025-02-22T21:07:32.225Z

    String? id = await AppUsageService.getUserId();
    if (formstate.currentState!.validate()) {
      return FirebaseFirestore.instance.collection('services').add({
        'userName': userName.text,
        'userId': id,
        'userEmail': email.text,
        'message': message.text,
        'dataAdd': formattedDate,
        'dataUpdate': formattedDate,
        'state': 'new',
      }).then((value) {
        showCustomSnackBar("done".tr, isError: false);
        Get.back();
      }).catchError((error) => print("Failed to update user: $error"));
    }
  }

  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    message.dispose();
    super.dispose();
  }
}
