import 'package:duegas/features/app/model/reward_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RewardHistoryList extends StatelessWidget {
  final List<RewardHistoryModel> history;

  const RewardHistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No reward history available.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // Important for nesting
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final record = history[index];
        final isEarned = record.type == 'earned';
        final color = isEarned ? Colors.green : Colors.red;
        final icon = isEarned ? Icons.arrow_downward : Icons.arrow_upward;

        return Card(
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            title: Text(
              isEarned ? "Earned Reward" : "Redeemed Reward",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('MMM dd, yyyy • hh:mm a').format(record.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: Text(
              "${isEarned ? '+' : '-'}${currencyFormat.format(record.amount)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
