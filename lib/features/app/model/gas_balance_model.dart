import 'package:cloud_firestore/cloud_firestore.dart';

class GasBalanceModel {
  String? id;
  String? total;
  String? oneKg;
  DateTime? createdAt;
  DateTime? updatedAt;

  GasBalanceModel({
    this.id,
    this.total,
    this.oneKg,
    this.createdAt,
    this.updatedAt,
  });

  factory GasBalanceModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return GasBalanceModel(
      id: id,
      total: json['total'] as String?,
      oneKg: json['oneKg'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'oneKg': oneKg,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
