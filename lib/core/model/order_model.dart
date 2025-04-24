class OrderModel {
  String address;
  String deliveryCost;
  String deliveryTime;
  String state;
  String itemCount;
  String payment;
  String phoneNumber;
  String totlePrice;
  String userId;
  String dataAdd;
  OrderModel({
    required this.address,
    required this.deliveryCost,
    required this.deliveryTime,
    required this.itemCount,
    required this.payment,
    required this.state,
    required this.phoneNumber,
    required this.totlePrice,
    required this.userId,
    required this.dataAdd,
  });

  OrderModel.fromFireStore(Map<String, dynamic> data)
      : this(
          deliveryTime: data['deliveryTime'],
          address: data['address'],
          deliveryCost: data['deliveryCost'],
          itemCount: data['itemCount'],
          payment: data['payment'],
          state: data['state'],
          phoneNumber: data['phoneNumber'],
          totlePrice: data['totlePrice'],
          userId: data['userId'],
          dataAdd: data['dataAdd'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'address': address,
      'deliveryTime': deliveryTime,
      'deliveryCost': deliveryCost,
      'itemCount': itemCount,
      'payment': payment,
      'state': state,
      'phoneNumber': phoneNumber,
      'totlePrice': totlePrice,
      'userId': userId,
      'dataAdd': dataAdd,
    };
  }
}

class DetiliesOrderModel {
  String discount;
  String idBills;
  String idItem;
  String itemCount;
  String itemPrice;
  String nameItem;
  String totlePrice;

  DetiliesOrderModel({
    required this.discount,
    required this.idBills,
    required this.idItem,
    required this.itemCount,
    required this.itemPrice,
    required this.nameItem,
    required this.totlePrice,
  });

  DetiliesOrderModel.fromFireStore(Map<String, dynamic> data)
      : this(
          idItem: data['idItem'],
          discount: data['discount'],
          idBills: data['idBills'],
          itemCount: data['itemCount'],
          itemPrice: data['itemPrice'],
          nameItem: data['nameItem'],
          totlePrice: data['totlePrice'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'discount': discount,
      'idItem': idItem,
      'idBills': idBills,
      'itemCount': itemCount,
      'itemPrice': itemPrice,
      'nameItem': nameItem,
      'totlePrice': totlePrice,
    };
  }
}
