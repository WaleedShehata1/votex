// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  String brandName;
  String imageUrl;
  String BrandId;
  BrandModel({
    this.BrandId = '',
    required this.brandName,
    required this.imageUrl,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'brand_id': BrandId,
      'brand_name': brandName,
      'imageUrl': imageUrl,
    };
  }

  factory BrandModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BrandModel(
      imageUrl: data['imageUrl'],
      brandName: data['brand_name'],
    );
  }
}
