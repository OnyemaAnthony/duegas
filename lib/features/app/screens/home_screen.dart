import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import the intl package

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Consumer<AppProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 30),
                    _buildSalesCard(),
                    const SizedBox(height: 30),
                    _buildGasBalance(provider),
                    const SizedBox(height: 30),
                    _buildRecentTransactions(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              color: Colors.grey,
              fontFamily: 'SFProDisplay',
            ),
            children: [
              TextSpan(text: 'Welcome '),
              TextSpan(
                text: 'Jude!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _showSettingsDialog(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // ... (The rest of your existing widgets: _buildSalesCard, _buildGasBalance, etc. remain the same)
  Widget _buildSalesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sales',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('₦6500.00',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
              _buildTimeFilter(),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: _buildLineChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildFilterButton('1D', isSelected: true),
          _buildFilterButton('7D'),
          _buildFilterButton('30D'),
          _buildFilterButton('1Y'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade600 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final List<FlSpot> spots = [
      const FlSpot(0, 80),
      const FlSpot(1, 210),
      const FlSpot(2, 100),
      const FlSpot(3, 180),
      const FlSpot(4, 70),
    ];

    return LineChart(
      LineChartData(
        showingTooltipIndicators: [
          ShowingTooltipIndicators([
            LineBarSpot(
              LineChartBarData(spots: spots),
              0, // bar index
              spots[3], // spot index
            ),
          ]),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                return LineTooltipItem(
                  '₦${barSpot.y.toInt()}',
                  const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.white54, fontSize: 12);
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Jan', style: style);
                    break;
                  case 1:
                    text = const Text('Feb', style: style);
                    break;
                  case 2:
                    text = const Text('Mar', style: style);
                    break;
                  case 3:
                    text = const Text('Apr', style: style);
                    break;
                  case 4:
                    text = const Text('May', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return Container();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.white,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                if (index == 3) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.purple.shade200,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(radius: 0);
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGasBalance(AppProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gas balance',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            provider.gasBalance == null
                ? Text('No Gas')
                : RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: currencyFormatter.format(
                            double.parse(
                              provider.gasBalance!.total!,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' Kg',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
        // Row(
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {},
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.green,
        //         foregroundColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20)),
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        //       ),
        //       child: const Text('Refill'),
        //     ),
        //     const SizedBox(width: 8),
        //     ElevatedButton(
        //       onPressed: () {},
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.red,
        //         foregroundColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20)),
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        //       ),
        //       child: const Text('Reset'),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildTransactionItem(
            'Mrs Effiong AKpabio', '9:01am', '₦13.10', 'assets/avatar1.jpg'),
        _buildTransactionItem(
            'Engr Godswill Emmanuel', '9:01am', '₦13.10', 'assets/avatar2.jpg'),
        _buildTransactionItem('Hyginus Mgbojikwe', '9:01am', '₦13.10', null),
        _buildTransactionItem(
            'Bald Anthony Onyeama', '9:01am', '₦13.10', 'assets/avatar3.jpg'),
      ],
    );
  }

  Widget _buildTransactionItem(
      String name, String time, String amount, String? avatarPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, color: Colors.grey)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          Text(amount,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

void _showSettingsDialog(BuildContext dialogContext) {
  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return Consumer<AppProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return StatefulBuilder(builder: (context, setState) {
          final TextEditingController quantityController =
              TextEditingController();
          final TextEditingController priceController = TextEditingController();

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(quantityController, "Price of (1Kg)",
                            false, 'Enter price of 1kg in (₦)'),
                        const SizedBox(height: 15),
                        _buildTextField(priceController, "Quantity", false,
                            'Enter quantity of Gas'),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await provider.saveBalance(
                            GasBalanceModel(
                                total: priceController.text,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                                oneKg: quantityController.text),
                          );
                          if (!dialogContext.mounted) return;
                          dialogContext.showCustomToast(
                              message: "Balance set successfully");
                          Navigator.of(dialogContext).pop();
                        } catch (e) {
                          dialogContext.showCustomToast(message: e.toString());
                        }
                      },
                      child: const Text(
                        'Save & Continue',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
    },
  );
}

Widget _buildTextField(TextEditingController controller, String label,
    bool readOnly, String hint) {
  return TextField(
    controller: controller,
    readOnly: readOnly,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

String _extractRawValue(String formatted) {
  final digitsOnly = formatted.replaceAll(RegExp(r'[^0-9]'), '');
  if (digitsOnly.isEmpty) return '0.00';
  final value = double.parse(digitsOnly) / 100;
  return value.toStringAsFixed(2); // Returns clean numeric string
}
