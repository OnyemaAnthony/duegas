import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  String? id;
  String? customersId;
  String? customersName;
  double? priceInNaira;
  double? quantityInKg;
  DateTime? createdAt;
  DateTime? updatedAt;

  SalesModel({
    this.id,
    this.customersId,
    this.customersName,
    this.priceInNaira,
    this.quantityInKg,
    this.createdAt,
    this.updatedAt,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return SalesModel(
      id: docId ?? json['id'],
      customersId: json['customersId'] as String?,
      customersName: json['customersName'] as String?,
      priceInNaira: (json['priceInNaira'] as num?)?.toDouble(),
      quantityInKg: (json['quantityInKg'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customersId': customersId,
      'customersName': customersName,
      'priceInNaira': priceInNaira,
      'quantityInKg': quantityInKg,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
