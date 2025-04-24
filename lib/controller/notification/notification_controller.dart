import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/model/notification_model.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var fcmToken = ''.obs; // Observable variable
  final users = FirebaseFirestore.instance.collection('users');
  List<NotificationModel> listNotifications = [];
  @override
  void onInit() async {
    // await iniNotifications();
    super.onInit();
    getUserData();
    getToken();
  }

  String formatDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd').format(dateTime);
    return formattedDate;
  }
  // Future<void> iniNotifications() async {
  //   await _firebaseMessaging.requestPermission();
  //   final token = await _firebaseMessaging.getToken();
  //   print("FCM Token:-- $token");
  //   FirebaseMessaging.onBackgroundMessage(handlebackgroundMessage);
  // }

  // Future<void> handlebackgroundMessage(RemoteMessage? message) async {
  //   print('title: ${message!.notification!.title}');
  //   print('title: ${message.notification!.body}');
  //   print('title: ${message.data}');
  // }

  Future<void> getToken() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    // FirebaseMessaging.onBackgroundMessage(handlebackgroundMessage);
    if (token != null) {
      fcmToken.value = token;
      print("FCM Token:-- $token");
    }
  }

  Future<void> getUserData() async {
    String? id = await AppUsageService.getUserId();
    QuerySnapshot notifications =
        await users.doc(id).collection('notifications').get();
    for (var not in notifications.docs) {
      listNotifications.add(NotificationModel(
          title: not['title'],
          description: not['description'],
          date: not['date']));
    }
    update();
  }
}
