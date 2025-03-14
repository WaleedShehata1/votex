class AuthResponse {
  final User user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final String id;
  final String userName;
  final String normalizedUserName;
  final String email;
  final String normalizedEmail;
  final bool emailConfirmed;
  final String passwordHash;
  final String securityStamp;
  final String concurrencyStamp;
  final String? phoneNumber;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final String? lockoutEnd;
  final bool lockoutEnabled;
  final int accessFailedCount;
  final String? address;
  final bool block;
  final String? fullName;
  final String? phoneNumber2;
  final String typeUser;
  final String dateAdd;
  final String userUpdate;
  final String dateUpdate;
  final String? cityId;
  final String? city;
  final List<Role>? roles;

  User({
    required this.id,
    required this.userName,
    required this.normalizedUserName,
    required this.email,
    required this.normalizedEmail,
    required this.emailConfirmed,
    required this.passwordHash,
    required this.securityStamp,
    required this.concurrencyStamp,
    this.phoneNumber,
    required this.phoneNumberConfirmed,
    required this.twoFactorEnabled,
    this.lockoutEnd,
    required this.lockoutEnabled,
    required this.accessFailedCount,
    this.address,
    required this.block,
    this.fullName,
    this.phoneNumber2,
    required this.typeUser,
    required this.dateAdd,
    required this.userUpdate,
    required this.dateUpdate,
    this.cityId,
    this.city,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      normalizedUserName: json['normalizedUserName'],
      email: json['email'],
      normalizedEmail: json['normalizedEmail'],
      emailConfirmed: json['emailConfirmed'],
      passwordHash: json['passwordHash'],
      securityStamp: json['securityStamp'],
      concurrencyStamp: json['concurrencyStamp'],
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      twoFactorEnabled: json['twoFactorEnabled'],
      lockoutEnd: json['lockoutEnd'],
      lockoutEnabled: json['lockoutEnabled'],
      accessFailedCount: json['accessFailedCount'],
      address: json['address'],
      block: json['block'],
      fullName: json['fullName'],
      phoneNumber2: json['phoneNumber2'],
      typeUser: json['typeUser'],
      dateAdd: json['dateAdd'],
      userUpdate: json['userUpdate'],
      dateUpdate: json['dateUpdate'],
      cityId: json['cityId'],
      city: json['city'],
      roles: (json['roles'] as List?)
          ?.map((role) => Role?.fromJson(role))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'normalizedUserName': normalizedUserName,
      'email': email,
      'normalizedEmail': normalizedEmail,
      'emailConfirmed': emailConfirmed,
      'passwordHash': passwordHash,
      'securityStamp': securityStamp,
      'concurrencyStamp': concurrencyStamp,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'twoFactorEnabled': twoFactorEnabled,
      'lockoutEnd': lockoutEnd,
      'lockoutEnabled': lockoutEnabled,
      'accessFailedCount': accessFailedCount,
      'address': address,
      'block': block,
      'fullName': fullName,
      'phoneNumber2': phoneNumber2,
      'typeUser': typeUser,
      'dateAdd': dateAdd,
      'userUpdate': userUpdate,
      'dateUpdate': dateUpdate,
      'cityId': cityId,
      'city': city,
      'roles': roles?.map((role) => role.toJson()).toList(),
    };
  }
}

class Role {
  final String id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
