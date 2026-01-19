import 'package:duegas/core/utils/redemption_dialog.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/screens/reward_history_list.dart';
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

class CustomerDetailsContent extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailsContent({super.key, required this.customer});

  @override
  State<CustomerDetailsContent> createState() => _CustomerDetailsContentState();
}

class _CustomerDetailsContentState extends State<CustomerDetailsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.customer.id != null) {
        context.read<AppProvider>().getRewardHistory(widget.customer.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final appProvider = context.watch<AppProvider>(); // Removed if not needed elsewhere
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    final points = widget.customer.points ?? 0.0;
    final isEligible = points > 0;

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
                            widget.customer.name?.isNotEmpty == true
                                ? widget.customer.name!
                                    .split('')
                                    .first
                                    .toUpperCase()
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
                          widget.customer.name ?? 'Unknown Customer',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (isEligible)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Chip(
                              label: Text(
                                  "Balance: ${currencyFormatter.format(points)}",
                                  style: const TextStyle(color: Colors.white)),
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
                                    currencyFormatter.format(points),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber[900]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Cash Value Reward",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: isEligible
                                      ? () => showRedemptionDialog(
                                          context, widget.customer)
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
                          value: widget.customer.phoneNumber,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: "Date of Birth",
                          value: widget.customer.dob != null
                              ? DateFormat('dd MMM yyyy')
                                  .format(widget.customer.dob!)
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.access_time,
                          title: "Joined",
                          value: widget.customer.createdAt != null
                              ? DateFormat('dd MMM yyyy')
                                  .format(widget.customer.createdAt!)
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          title: "Total Net Spend",
                          value: currencyFormatter
                              .format(widget.customer.netSpend ?? 0),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 32),
                // --- REWARD HISTORY ---
                Text(
                  "Reward History",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
                const SizedBox(height: 16),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return RewardHistoryList(history: provider.rewardHistory);
                  },
                ),
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
