import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String itemId,
      brandName,
      brandId,
      imageUrl,
      itemDescription,
      itemName,
      discount,
      imageIcon,
      idSubCategory,
      price,
      rate,
      stock,
      dateAdd,
      supCategory,
      videoUrl;
  int count;
  bool isMoreSale;

  ItemModel({
    required this.itemId,
    required this.brandName,
    required this.brandId,
    required this.isMoreSale,
    required this.imageUrl,
    required this.itemDescription,
    required this.itemName,
    required this.discount,
    required this.imageIcon,
    required this.idSubCategory,
    required this.price,
    required this.rate,
    required this.stock,
    required this.supCategory,
    required this.videoUrl,
    required this.dateAdd,
    this.count = 1,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      itemId: data['item_id'], //doc.get("productId"),
      brandName: data['brand'],
      brandId: data['brand_id'],
      isMoreSale: data['isMoreSale'],
      imageUrl: data['imageUrl'],
      itemDescription: data['description'],
      itemName: data['name'],
      discount: data['discount'],
      imageIcon: data['imageIcon'],
      idSubCategory: data['idSubCategory'],
      price: data['price'],
      rate: data['rate'],
      stock: data['stock'],
      supCategory: data['supCategory'],
      videoUrl: data['videoUrl'],
      dateAdd: data['dateAdd'],
    );
  }
}
