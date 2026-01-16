import 'package:duegas/core/utils/redemption_dialog.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Customer Details'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: CustomerDetailsContent(customer: customer),
    );
  }
}

class CustomerDetailsContent extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsContent({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final minPoints = appProvider.gasBalance?.minimumPointForRewards ?? 10;
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    final points = customer.points ?? 0.0;
    final isEligible = points >= minPoints;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- HEADER CARD ---
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              isEligible ? Colors.green[100] : Colors.grey[200],
                          child: Text(
                            customer.name?.isNotEmpty == true
                                ? customer.name!.split('').first.toUpperCase()
                                : '?',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: isEligible
                                    ? Colors.green[800]
                                    : Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          customer.name ?? 'Unknown Customer',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (isEligible)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Chip(
                              label: const Text("Eligible for Reward",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        const SizedBox(height: 32),
                        // --- LOYALTY SECTION ---
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.stars,
                                      size: 32, color: Colors.amber[800]),
                                  const SizedBox(width: 8),
                                  Text(
                                    "$points Points",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber[900]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: (points / minPoints).clamp(0.0, 1.0),
                                backgroundColor: Colors.amber[100],
                                color: Colors.green,
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isEligible
                                    ? "Ready to redeem!"
                                    : "${(minPoints - points).toStringAsFixed(1)} more points to reach reward",
                                style: TextStyle(
                                    color: Colors.amber[900],
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: isEligible
                                      ? () => showRedemptionDialog(
                                          context, customer, minPoints)
                                      : null,
                                  icon: const Icon(Icons.redeem),
                                  label: const Text("Redeem Rewards"),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey[300],
                                    disabledForegroundColor: Colors.grey[500],
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // --- INFO GRID ---
                Text(
                  "Customer Information",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  // Calculate item width: (Total Width - Spacing) / Columns
                  // If wide (2 cols), subtract spacing (16) and divide by 2.
                  // If narrow (1 col), full width.
                  final itemWidth = isWide
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.phone,
                          title: "Phone Number",
                          value: customer.phoneNumber,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: "Date of Birth",
                          value: customer.dob != null
                              ? DateFormat('dd MMM yyyy').format(customer.dob!)
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.access_time,
                          title: "Joined",
                          value: customer.createdAt != null
                              ? DateFormat('dd MMM yyyy')
                                  .format(customer.createdAt!)
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          title: "Total Net Spend",
                          value:
                              currencyFormatter.format(customer.netSpend ?? 0),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required String title, String? value}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text(
                    value ?? 'N/A',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
