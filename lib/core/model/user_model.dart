import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userName;
  String phone;
  String email;
  String uid;
  String address;
  String tokenDevice;
  UserModel({
    this.uid = '',
    this.address = '',
    this.tokenDevice = '',
    required this.userName,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'uid': uid,
      'user_name': userName,
      'address': address,
      'email': email,
      'tokenDevice': tokenDevice,
      'phone': phone,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      userName: data['user_name'],
      tokenDevice: data['tokenDevice'],
      address: data['address'],
      phone: data['phone'],
    );
  }
}
