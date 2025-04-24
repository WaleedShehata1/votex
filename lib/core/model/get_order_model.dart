// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class GetOrderModel {
  final String address;
  final String orderId;
  final String phoneNumber;
  final String deliveryTime;
  final String totlePrice;
  final String payment;
  final String state;
  final String userId;
  final String deliveryCost;
  final String itemCount;
  final String dataAdd;
  final List<BillModel> bills;

  GetOrderModel({
    this.orderId = '',
    required this.address,
    required this.phoneNumber,
    required this.deliveryTime,
    required this.totlePrice,
    required this.payment,
    required this.state,
    required this.userId,
    required this.deliveryCost,
    required this.itemCount,
    required this.dataAdd,
    required this.bills,
  });

  factory GetOrderModel.fromFirestore(
      id, DocumentSnapshot doc, List<BillModel> bills) {
    Map data = doc.data() as Map<String, dynamic>;
    return GetOrderModel(
      orderId: id,
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      deliveryTime: data['deliveryTime'] ?? '',
      totlePrice: data['totlePrice'] ?? '',
      payment: data['payment'] ?? '',
      state: data['state'] ?? '',
      userId: data['userId'] ?? '',
      deliveryCost: data['deliveryCost'] ?? '',
      itemCount: data['itemCount'] ?? '',
      dataAdd: data['dataAdd'] ?? '',
      bills: bills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'phoneNumber': phoneNumber,
      'deliveryTime': deliveryTime,
      'totlePrice': totlePrice,
      'payment': payment,
      'state': state,
      'userId': userId,
      'deliveryCost': deliveryCost,
      'itemCount': itemCount,
    };
  }
}

class BillModel {
  final String totlePrice;
  final String idBills;
  final String discount;
  final String itemPrice;
  final String idItem;
  final String nameItem;
  final String itemCount;

  BillModel({
    required this.totlePrice,
    required this.idBills,
    required this.discount,
    required this.itemPrice,
    required this.idItem,
    required this.nameItem,
    required this.itemCount,
  });

  factory BillModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BillModel(
      totlePrice: data['totlePrice'] ?? '',
      idBills: data['idBills'] ?? '',
      discount: data['discount'] ?? '',
      itemPrice: data['itemPrice'] ?? '',
      idItem: data['idItem'] ?? '',
      nameItem: data['nameItem'] ?? '',
      itemCount: data['itemCount'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totlePrice': totlePrice,
      'idBills': idBills,
      'discount': discount,
      'itemPrice': itemPrice,
      'idItem': idItem,
      'nameItem': nameItem,
      'itemCount': itemCount,
    };
  }
}

class screenOrder {
  String title;
  String description;
  String orderNumber;
  String date;
  String image;
  screenOrder({
    required this.title,
    required this.description,
    required this.orderNumber,
    required this.date,
    required this.image,
  });
}
