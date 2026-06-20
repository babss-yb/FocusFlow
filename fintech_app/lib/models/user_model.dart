/// Modèle représentant un utilisateur PME.
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? companyName;
  final String? companyType;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime createdAt;
  final String? referralCode;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.companyName,
    this.companyType,
    this.avatarUrl,
    this.isVerified = false,
    required this.createdAt,
    this.referralCode,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'companyName': companyName,
      'companyType': companyType,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'referralCode': referralCode,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      companyName: map['companyName'],
      companyType: map['companyType'],
      avatarUrl: map['avatarUrl'],
      isVerified: map['isVerified'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      referralCode: map['referralCode'],
    );
  }

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? companyName,
    String? companyType,
    String? avatarUrl,
    bool? isVerified,
    String? referralCode,
  }) {
    return UserModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      companyName: companyName ?? this.companyName,
      companyType: companyType ?? this.companyType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
      referralCode: referralCode ?? this.referralCode,
    );
  }
}
