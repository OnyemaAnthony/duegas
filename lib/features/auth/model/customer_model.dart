import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? name;
  String? phoneNumber;
  double? netSpend;
  bool? hasBirthday;
  DateTime? dob;
  DateTime? createdAt;
  DateTime? updatedAt;

  CustomerModel({
    this.name,
    this.phoneNumber,
    this.netSpend,
    this.dob,
    this.hasBirthday,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return CustomerModel(
      name: id ?? json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      netSpend: (json['netSpend'] as num?)?.toDouble(),
      hasBirthday: json['hasBirthday'] as bool? ?? false,
      dob: (json['dob'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'netSpend': netSpend,
      'hasBirthday': hasBirthday ?? false,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
