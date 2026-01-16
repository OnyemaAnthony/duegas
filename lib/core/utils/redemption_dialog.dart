import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showRedemptionDialog(
    BuildContext context, CustomerModel customer, int minPoints) {
  final double currentPoints = customer.points ?? 0.0;
  final int rewardBlocks = (currentPoints / minPoints).floor();
  final double redeemablePoints = (rewardBlocks * minPoints).toDouble();
  final double remainingPoints = currentPoints - redeemablePoints;
  // Assuming 1 point = 1 KG of gas reward
  final double rewardGasKg = redeemablePoints;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Redeem Rewards"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${customer.name ?? 'Unknown'}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSummaryRow("Total Points:", "$currentPoints"),
            _buildSummaryRow(
                "Minimum for Reward:", "$minPoints points (= $minPoints KG)"),
            const Divider(),
            _buildSummaryRow("Redeemable Points:",
                "${redeemablePoints.toInt()} ($rewardBlocks rewards)",
                isHighlight: true),
            _buildSummaryRow("Reward (Gas):", "${rewardGasKg.toInt()} KG",
                isHighlight: true),
            const Divider(),
            _buildSummaryRow("Remaining Points:",
                remainingPoints.toStringAsFixed(remainingPoints == 0 ? 0 : 1)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: redeemablePoints > 0
                ? () async {
                    final appProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    final authProvider = Provider.of<AuthenticationProvider>(
                        context,
                        listen: false);

                    Navigator.pop(dialogContext); // Close dialog

                    try {
                      await appProvider.redeemPoints(
                        customerId: customer.id!,
                        pointsToRedeem: redeemablePoints,
                        gasAmountKg: rewardGasKg,
                      );

                      if (context.mounted) {
                        context.showCustomToast(
                            message: "Redemption successful!");
                        authProvider.getCustomers(refresh: true);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.showCustomToast(message: "Error: $e");
                      }
                    }
                  }
                : null, // Disable if 0 redeemable
            child: const Text("Redeem"),
          ),
        ],
      );
    },
  );
}

Widget _buildSummaryRow(String label, String value,
    {bool isHighlight = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isHighlight ? Colors.green[800] : Colors.grey[700],
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isHighlight ? Colors.green[800] : Colors.black)),
      ],
    ),
  );
}
