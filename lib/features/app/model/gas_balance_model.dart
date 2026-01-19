import 'package:cloud_firestore/cloud_firestore.dart';

class GasBalanceModel {
  String? id;
  double? totalPrice;
  double? priceOfOneKg;
  double? quantityKg;
  double? totalSales;
  DateTime? createdAt;
  DateTime? updatedAt;

  GasBalanceModel({
    this.id,
    this.totalPrice,
    this.priceOfOneKg,
    this.totalSales,
    this.quantityKg,
    this.createdAt,
    this.updatedAt,
  });

  factory GasBalanceModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return GasBalanceModel(
      id: id,
      totalPrice: json['totalPrice'] as double?,
      totalSales: json['totalSales'] as double?,
      priceOfOneKg: json['priceOfOneKg'] as double?,
      quantityKg: json['quantityKg'] as double?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPrice': totalPrice,
      'totalSales': totalSales,
      'priceOfOneKg': priceOfOneKg,
      'quantityKg': quantityKg,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
