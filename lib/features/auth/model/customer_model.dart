import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? name;
  String? phoneNumber;
  double? netSpend;
  bool? hasBirthday;
  DateTime? createdAt;
  DateTime? updatedAt;

  CustomerModel({
    this.name,
    this.phoneNumber,
    this.netSpend,
    this.hasBirthday,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      netSpend: (json['netSpend'] as num?)?.toDouble(),
      hasBirthday: json['hasBirthday'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'netSpend': netSpend,
      'hasBirthday': hasBirthday ?? false,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
