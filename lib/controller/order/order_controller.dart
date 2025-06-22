import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/model/get_order_model.dart';

class OrderController extends GetxController {
  final orders = FirebaseFirestore.instance.collection('Bills');
  List<GetOrderModel> order = [];
  List<screenOrder> listOrder = [];
  bool isLoading = false;
  Future<void> getOrder() async {
    isLoading = true;
    order = [];
    QuerySnapshot orders =
        await FirebaseFirestore.instance.collection("Bills").get();
    String? id = await AppUsageService.getUserId();

    for (var item in orders.docs) {
      if (item['userId'] == id) {
        List<BillModel> list = [];
        var orders2 =
            await FirebaseFirestore.instance
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
    if (orders.docs.isEmpty) {
      isLoading = false;
    }

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
                  listOrder.add(
                    screenOrder(
                      date: or.dataAdd,
                      title: bill.nameItem + documentSnapshot['brand'],
                      description: documentSnapshot['description'],
                      orderNumber: or.orderId,
                      image: documentSnapshot['imageIcon'],
                    ),
                  );
                }
              });
        }
      }
    }
    isLoading = false;
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
