import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  String serviceId;
  String userName;
  String userId;
  String userEmail;
  String message;
  String dataAdd;
  String dataUpdate;
  String state;
  ContactModel({
    this.serviceId = '',
    required this.userName,
    required this.userId,
    required this.userEmail,
    required this.message,
    required this.dataAdd,
    required this.dataUpdate,
    required this.state,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'serviceId': serviceId,
      'userName': userName,
      'userId': userId,
      'userEmail': userEmail,
      'message': message,
      'dataAdd': dataAdd,
      'dataUpdate': dataUpdate,
      'state': state,
    };
  }

  factory ContactModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ContactModel(
      serviceId: data['serviceId'],
      userName: data['userName'],
      userId: data['userId'],
      userEmail: data['userEmail'],
      message: data['message'],
      dataAdd: data['dataAdd'],
      dataUpdate: data['dataUpdate'],
      state: data['state'],
    );
  }
}
