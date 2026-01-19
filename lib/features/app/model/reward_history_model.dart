import 'package:cloud_firestore/cloud_firestore.dart';

class RewardHistoryModel {
  final String? id;
  final String userId;
  final double amount;
  final String type; // 'earned' | 'redeemed'
  final String source; // 'sale', 'redemption', 'manual_adjustment'
  final String? relatedSaleId;
  final double previousBalance;
  final double newBalance;
  final String status; // 'success', 'pending'
  final DateTime createdAt;

  RewardHistoryModel({
    this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.source,
    this.relatedSaleId,
    required this.previousBalance,
    required this.newBalance,
    required this.status,
    required this.createdAt,
  });

  factory RewardHistoryModel.fromJson(Map<String, dynamic> json,
      {String? docId}) {
    return RewardHistoryModel(
      id: docId,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      source: json['source'] as String,
      relatedSaleId: json['relatedSaleId'] as String?,
      previousBalance: (json['previousBalance'] as num).toDouble(),
      newBalance: (json['newBalance'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'type': type,
      'source': source,
      'relatedSaleId': relatedSaleId,
      'previousBalance': previousBalance,
      'newBalance': newBalance,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
