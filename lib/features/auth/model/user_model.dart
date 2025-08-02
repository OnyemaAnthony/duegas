import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? dob;
  String? gender;
  bool? isAdmin;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.dob,
    this.gender,
    this.isAdmin,
    this.updatedAt,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'dob': dob,
      'gender': gender,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
