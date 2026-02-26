import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? address;
  final DateTime? createdAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    this.address,
    this.createdAt,
    this.isEmailVerified = false,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phoneNumber,
    String? address,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatarUrl,
        phoneNumber,
        address,
        createdAt,
        isEmailVerified,
      ];
}
