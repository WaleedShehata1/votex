import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/model/get_order_model.dart';

class OrderController extends GetxController {
  final orders = FirebaseFirestore.instance.collection('Bills');
  List<GetOrderModel> order = [];
  List<screenOrder> listOrder = [];
  Future<void> getOrder() async {
    order = [];
    QuerySnapshot orders =
        await FirebaseFirestore.instance.collection("Bills").get();
    String? id = await AppUsageService.getUserId();
    // await orders.get().then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     model = UserModel.fromFirestore(documentSnapshot);
    //     userName.text = model!.userName;
    //     address.text = model!.address;
    //     phoneNumber.text = model!.phone;
    //   }
    //   print(documentSnapshot.exists);
    // });

    for (var item in orders.docs) {
      if (item['userId'] == id) {
        List<BillModel> list = [];
        var orders2 = await FirebaseFirestore.instance
            .collection("Bills")
            .doc(item.id)
            .collection('Bills')
            .get();

        for (var element in orders2.docs) {
          list.add(BillModel.fromFirestore(element));
        }
        order.add(GetOrderModel.fromFirestore(item.id, item, list));
      }
    }
    creatListOrders();
    update();
  }

  creatListOrders() async {
    if (order.isNotEmpty) {
      for (var or in order) {
        for (var bill in or.bills) {
          var items = await FirebaseFirestore.instance
              .collection("items")
              .doc(bill.idItem)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              listOrder.add(screenOrder(
                  date: or.dataAdd,
                  title: bill.nameItem + documentSnapshot['brand'],
                  description: documentSnapshot['description'],
                  orderNumber: or.orderId,
                  image: documentSnapshot['imageIcon']));
            }
          });
        }
      }
    }
    update();
  }

  String formatDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd').format(dateTime);
    return formattedDate;
  }

  @override
  void onInit() {
    getOrder();
    super.onInit();
  }
}
