import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/extensions/ui_extension.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:duegas/features/app/model/sales_model.dart';
import 'package:duegas/features/app/screens/sales_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                    _buildSalesCard(provider),
                    const SizedBox(height: 30),
                    _buildGasBalance(provider),
                    const SizedBox(height: 30),
                    _buildRecentTransactions(provider, context),
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
    final userModel =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontFamily: 'SFProDisplay',
            ),
            children: [
              TextSpan(text: 'Welcome '),
              TextSpan(
                text: userModel.user?.name!,
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

  Widget _buildSalesCard(AppProvider provider) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sales',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('₦${provider.gasBalance?.totalSales ?? 0.0}',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
              _buildTimeFilter(),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: _buildLineChart(provider),
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

  Widget _buildLineChart(AppProvider provider) {
    // Get sales data and group by month
    final sales = provider.sales ?? [];

    // If no sales data, return an empty container with a message
    if (sales.isEmpty) {
      return Center(
        child: Text(
          'No sales data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final monthlySales = <DateTime, double>{};
    for (final sale in sales) {
      final monthStart = DateTime(sale.createdAt!.year, sale.createdAt!.month);
      monthlySales.update(
        monthStart,
        (total) => total + (sale.priceInNaira ?? 0),
        ifAbsent: () => sale.priceInNaira ?? 0,
      );
    }

    // Sort months chronologically
    final sortedMonths = monthlySales.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    // Create spots for the chart
    final spots = sortedMonths.asMap().entries.map((entry) {
      final index = entry.key;
      final month = entry.value;
      final salesAmount = monthlySales[month] ?? 0;
      return FlSpot(index.toDouble(), salesAmount);
    }).toList();

    // Find max sales amount for scaling (with minimum of 30,000)
    final maxSalesAmount = monthlySales.values
        .fold(0.0, (max, amount) => amount > max ? amount : max);
    final maxY = maxSalesAmount > 30000 ? maxSalesAmount : 30000;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spots.length > 0 ? spots.length - 1 : 0,
        minY: 0,
        maxY: maxY.toDouble(),
        showingTooltipIndicators: spots.isNotEmpty
            ? [
                ShowingTooltipIndicators([
                  LineBarSpot(
                    LineChartBarData(spots: spots),
                    0,
                    spots.last,
                  ),
                ]),
              ]
            : [],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                return LineTooltipItem(
                  '₦${barSpot.y.toStringAsFixed(2)}',
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
                if (value.toInt() >= sortedMonths.length || value.toInt() < 0) {
                  return const Text('');
                }
                final month = sortedMonths[value.toInt()];
                final monthName = DateFormat('MMM').format(month);
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    monthName,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                );
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
                if (index == spots.length - 1) {
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
                            (provider.gasBalance!.totalPrice),
                          ),
                        ),
                        TextSpan(
                          text: '',
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
      ],
    );
  }

  Widget _buildRecentTransactions(AppProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Spacer(),
            Text('View all').onClick(() {
              AppRouter.getPage(
                context,
                SalesScreen(salesModel: provider.sales!),
              );
            }),
          ],
        ),
        _buildTransactionList(provider.sales!),
      ],
    );
  }

  Widget _buildTransactionList(List<SalesModel> sales) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sales.length,
        itemBuilder: (context, index) {
          final sale = sales[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(sale.customersName!.split('').first),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sale.customersName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(DateFormat('dd MMMM yyyy').format(sale.createdAt!),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                Text(' ₦${sale.priceInNaira!.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          );
        });
  }
}

void _showSettingsDialog(BuildContext dialogContext) {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return Consumer<AppProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return StatefulBuilder(builder: (context, setState) {
          void attachListeners() {
            priceController.addListener(() => setState(() {}));
            quantityController.addListener(() => setState(() {}));
          }

          attachListeners();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!priceController.hasListeners) attachListeners();
          });

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

                  // Input Fields
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
                        _buildTextField(
                          priceController,
                          "Price of (1Kg)",
                          false,
                          'Enter price of 1kg in (₦)',
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          quantityController,
                          "Quantity",
                          false,
                          'Enter quantity of Gas',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),
                  (priceController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty)
                      ? Text(
                          'Price in Naira: ₦${getTotalPrice(
                            double.tryParse(priceController.text) ?? 0,
                            double.tryParse(quantityController.text) ?? 0,
                          ).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      : const SizedBox.shrink(),

                  const SizedBox(height: 32),

                  // Submit Button
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
                        final price = double.tryParse(priceController.text);
                        final quantity =
                            double.tryParse(quantityController.text);

                        if (price == null || quantity == null) {
                          dialogContext.showCustomToast(
                              message: "Please enter valid numbers");
                          return;
                        }

                        try {
                          await provider.saveBalance(
                            GasBalanceModel(
                              totalPrice: getTotalPrice(price, quantity),
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              priceOfOneKg: price,
                              quantityKg: quantity,
                            ),
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

//
// void _showSettingsDialog(BuildContext dialogContext) {
//   showDialog(
//     context: dialogContext,
//     builder: (BuildContext context) {
//       return Consumer<AppProvider>(builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return StatefulBuilder(builder: (context, setState) {
//           final TextEditingController quantityController =
//               TextEditingController();
//           final TextEditingController priceController = TextEditingController();
//
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             child: Container(
//               padding: const EdgeInsets.all(24.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   // Header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Settings',
//                         style: TextStyle(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       InkWell(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade300,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.close, color: Colors.black54),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 32),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildTextField(quantityController, "Price of (1Kg)",
//                             false, 'Enter price of 1kg in (₦)'),
//                         const SizedBox(height: 15),
//                         _buildTextField(priceController, "Quantity", false,
//                             'Enter quantity of Gas'),
//                         const SizedBox(height: 22),
//                       ],
//                     ),
//                   ),
//                   priceController.text.isNotEmpty &&
//                           quantityController.text.isNotEmpty
//                       ? Text(
//                           'Price in Naira ${getTotalPrice(double.tryParse(priceController.text) ?? 0, double.tryParse(quantityController.text) ?? 0)}')
//                       : const SizedBox.shrink(),
//                   const SizedBox(height: 32),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         padding: const EdgeInsets.symmetric(vertical: 16.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                       ),
//                       onPressed: () async {
//                         try {
//                           await provider.saveBalance(
//                             GasBalanceModel(
//                                 totalPrice: getTotalPrice(
//                                     double.parse(priceController.text),
//                                     double.parse(quantityController.text)),
//                                 createdAt: DateTime.now(),
//                                 updatedAt: DateTime.now(),
//                                 priceOfOneKg:
//                                     double.parse(priceController.text),
//                                 quantityKg:
//                                     double.parse(quantityController.text)),
//                           );
//                           if (!dialogContext.mounted) return;
//                           dialogContext.showCustomToast(
//                               message: "Balance set successfully");
//                           Navigator.of(dialogContext).pop();
//                         } catch (e) {
//                           dialogContext.showCustomToast(message: e.toString());
//                         }
//                       },
//                       child: const Text(
//                         'Save & Continue',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//       });
//     },
//   );
// }

double getTotalPrice(double price, double quantity) {
  return quantity * price;
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
