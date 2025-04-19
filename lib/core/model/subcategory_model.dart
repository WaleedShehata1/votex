// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class SubcategoryModel {
  String idSubCategores;
  String imageSubCategores;
  String nameCategores;
  SubcategoryModel({
    this.idSubCategores = '',
    required this.imageSubCategores,
    required this.nameCategores,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'idSubCategores': idSubCategores,
      'imageSubCategores': imageSubCategores,
      'imageUrl': nameCategores,
    };
  }

  factory SubcategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SubcategoryModel(
      imageSubCategores: data['imageSubCategores'],
      nameCategores: data['nameCategores'],
    );
  }
}
