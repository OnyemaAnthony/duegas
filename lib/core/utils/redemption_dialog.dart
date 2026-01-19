import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void showRedemptionDialog(BuildContext context, CustomerModel customer) {
  final double currentPointsValue = customer.points ?? 0.0;
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'en_NG', symbol: '₦');

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
            const Text(
              "Rewards are now cash value! You can redeem your entire balance to pay for gas.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow("Total Reward Balance:",
                currencyFormat.format(currentPointsValue),
                isHighlight: true),
            const Divider(),
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
            onPressed: currentPointsValue > 0
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
                      );

                      if (context.mounted) {
                        context.showCustomToast(
                            message:
                                "Redemption successful! Value deducted from inventory.");
                        authProvider.getCustomers(refresh: true);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.showCustomToast(message: "Error: $e");
                      }
                    }
                  }
                : null, // Disable if 0 balance
            child: const Text("Redeem Full Balance"),
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
