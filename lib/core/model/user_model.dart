class UserModel {
  String userName;
  String phone;
  String email;
  String uid;
  UserModel({
    this.uid = '',
    required this.userName,
    required this.phone,
    required this.email,
  });

  UserModel.fromFireStore(Map<String, dynamic> data)
      : this(
          uid: data['uid'],
          email: data['email'],
          userName: data['user_name'],
          phone: data['phone'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'uid': uid,
      'user_name': userName,
      'email': email,
      'phone': phone,
    };
  }
}
