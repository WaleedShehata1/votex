import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? itemId;
  final String brandName,
      brandId,
      imageUrl,
      itemDescription,
      itemName,
      imageIcon,
      idSubCategory,
      rate,
      stock,
      dateAdd,
      supCategory,
      videoUrl;
  int count;
  int itemSell;
  double price;
  double discount;
  bool isMoreSale;

  ItemModel({
    this.itemId,
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
    required this.itemSell,
    this.count = 1,
  });

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      //doc.get("productId"),
      brandName: data['brand'],
      brandId: data['brand_id'],
      isMoreSale: data['isMoreSale'],
      imageUrl: data['imageUrl'],
      itemDescription: data['description'],
      itemName: data['name'],
      discount: double.parse(data['discount'].toString()),
      imageIcon: data['imageIcon'],
      idSubCategory: data['idSubCategory'],
      price: double.parse(data['price'].toString()),
      rate: data['rate'],
      stock: data['stock'],
      supCategory: data['supCategory'],
      videoUrl: data['videoUrl'],
      dateAdd: data['dateAdd'],
      itemSell: data['itemSell'],
    );
  }
  Map<String, dynamic> toFireStore() {
    return {
      'brand': brandName,
      'brand_id': brandId,
      'isMoreSale': isMoreSale,
      'imageUrl': imageUrl,
      'description': itemDescription,
      'name': itemName,
      'discount': discount,
      'imageIcon': imageIcon,
      'idSubCategory': idSubCategory,
      'price': price,
      'rate': rate,
      'stock': stock,
      'supCategory': supCategory,
      'videoUrl': videoUrl,
      'dateAdd': dateAdd,
      'itemSell': itemSell,
    };
  }
}

enum SortType {
  priceLowToHigh,
  priceHighToLow,
  // bestSelling,
  newestFirst,
  oldestFirst,
  fromAToZ,
  fromZToA,
}
