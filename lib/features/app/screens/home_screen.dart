import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/model/gas_balance_model.dart';
import 'package:duegas/features/app/model/sales_model.dart';
import 'package:duegas/features/app/screens/sales_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/widgets/printing_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Consumer2<AppProvider, AuthenticationProvider>(
        builder: (context, provider, authProvider, child) {
          // Use a specific loading check for filtered sales
          if (provider.isLoading && provider.filteredSales.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (authProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 960;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, authProvider),
                        const SizedBox(height: 24),
                        _buildStatsGrid(context, provider, isWide),
                        const SizedBox(height: 24),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child:
                                    _buildRevenueChartCard(context, provider),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 1,
                                child: _buildGasLevelCard(provider),
                              ),
                            ],
                          )
                        else ...[
                          _buildRevenueChartCard(context, provider),
                          const SizedBox(height: 24),
                          _buildGasLevelCard(provider),
                        ],
                        const SizedBox(height: 24),
                        _buildRecentTransactionsCard(provider, context),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AuthenticationProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 24, color: Colors.grey, fontFamily: 'SFProDisplay'),
            children: [
              const TextSpan(text: 'Welcome, '),
              TextSpan(
                text: authProvider.user?.name ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        if (authProvider.user!.isAdmin!)
          Tooltip(
            message: 'Settings',
            child: IconButton(
              onPressed: () {
                _showSettingsDialog(context);
              },
              icon: const Icon(Icons.settings_outlined, color: Colors.black54),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
      ],
    );
  }

  // --- STATS GRID ---
  Widget _buildStatsGrid(
      BuildContext context, AppProvider provider, bool isWide) {
    // Totals
    final totalRevenue = provider.totalFilteredSales;
    final totalTransactions = provider.filteredSales.length;
    final avgTransaction =
        totalTransactions > 0 ? totalRevenue / totalTransactions : 0.0;
    // Current Gas
    final currentGas = provider.gasBalance?.quantityKg ?? 0.0;

    final stats = [
      _StatItem(
        title: "Total Revenue",
        value: currencyFormatter.format(totalRevenue),
        icon: Icons.attach_money,
        color: Colors.green,
      ),
      _StatItem(
        title: "Current Gas",
        value: "${currentGas.toStringAsFixed(1)} Kg",
        icon: Icons.local_gas_station,
        color: Colors.blue,
      ),
      _StatItem(
        title: "Transactions",
        value: "$totalTransactions",
        icon: Icons.receipt_long,
        color: Colors.orange,
      ),
      _StatItem(
        title: "Avg. Sale",
        value: currencyFormatter.format(avgTransaction),
        icon: Icons.analytics,
        color: Colors.purple,
      ),
    ];

    return isWide
        ? Row(
            children: stats
                .map((stat) => Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildStatCard(stat),
                    )))
                .toList(),
          )
        : Wrap(
            spacing: 16,
            runSpacing: 16,
            children: stats
                .map((stat) => SizedBox(
                      width: (1000 - 48) / 2, // Approximate for mobile
                      child: _buildStatCard(stat),
                    ))
                .toList(),
          );
  }

  Widget _buildStatCard(_StatItem stat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(stat.icon, color: stat.color, size: 20),
              ),
              // Optionally add a trend indicator here
            ],
          ),
          const SizedBox(height: 16),
          Text(stat.value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(stat.title,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  // --- REVENUE CHART ---
  Widget _buildRevenueChartCard(BuildContext context, AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
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
                  Text("Revenue Analysis",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Sales performance over time",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              _buildTimeFilter(context, provider),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(height: 300, child: _buildLineChart(provider)),
        ],
      ),
    );
  }

  // --- GAS LEVEL CARD ---
  Widget _buildGasLevelCard(AppProvider provider) {
    final current = provider.gasBalance?.quantityKg ?? 0.0;
    // Assuming a max capacity for the progress bar visuals, or logic to handle scale
    // Since we don't have 'maxCapacity' in model, let's treat 'current + totalSales' roughly or just visual
    // For now, let's just make it look good. Ideally, user sets 'max capacity'.
    // Let's assume 1000kg visual max, or 100% full if no max known is weird.
    // Better: Just show the visual bar relative to some reasonable max (e.g. 1000 or current * 1.5)
    final double visualMax = (current < 100) ? 100 : current * 1.2;
    final double percent = (current / visualMax).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gas Monitor",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(provider.gasBalance != null ? "Active Inventory" : "Not Set",
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 32),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[100],
                    color: current < 50 ? Colors.red : Colors.blue,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${current.toStringAsFixed(1)}",
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const Text("Kg Available",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Value:", style: TextStyle(color: Colors.grey[600])),
              Text(
                currencyFormatter.format(provider.gasBalance?.totalPrice ?? 0),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- RECENT TRANSACTIONS ---
  Widget _buildRecentTransactionsCard(
      AppProvider provider, BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => AppRouter.getPage(
                      context, SalesScreen(salesModel: provider.sales)),
                  child: const Text('View all',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider.sales.isEmpty)
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No transactions yet.')))
            else
              _buildTransactionDataTable(provider.sales, context),
          ],
        ),
      ),
    );
  }

  // ... (Keep existing _buildTimeFilter, _buildFilterButton, _buildDatePickerButton, _buildLineChart logic but update chart styling/colors) ...
  // Re-implementing chart to be cleaner for white bg

  Widget _buildTimeFilter(BuildContext context, AppProvider provider) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterButton(context, '1D', provider),
          _buildFilterButton(context, '7D', provider),
          _buildFilterButton(context, '30D', provider),
          _buildDatePickerButton(context, provider),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
      BuildContext context, String text, AppProvider provider) {
    bool isSelected = provider.selectedFilter == text;
    return GestureDetector(
      onTap: () => provider.fetchSalesByFilter(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12)),
      ),
    );
  }

  Widget _buildDatePickerButton(BuildContext context, AppProvider provider) {
    bool isSelected = provider.selectedFilter == 'Custom';
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: provider.customDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          provider.fetchSalesByFilter('Custom', date: picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 14, color: isSelected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              isSelected && provider.customDate != null
                  ? DateFormat('MMM d').format(provider.customDate!)
                  : 'Date',
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(AppProvider provider) {
    final sales = provider.filteredSales;
    if (sales.isEmpty) {
      return const Center(
          child: Text('No sales data for this period',
              style: TextStyle(color: Colors.grey)));
    }

    final Map<DateTime, double> aggregatedSales = {};
    final String filter = provider.selectedFilter;

    if (filter == '1D' || filter == 'Custom') {
      for (final sale in sales) {
        final hourStart = DateTime(sale.createdAt!.year, sale.createdAt!.month,
            sale.createdAt!.day, sale.createdAt!.hour);
        aggregatedSales.update(
            hourStart, (total) => total + (sale.priceInNaira ?? 0),
            ifAbsent: () => sale.priceInNaira ?? 0);
      }
    } else {
      for (final sale in sales) {
        final dayStart = DateTime(
            sale.createdAt!.year, sale.createdAt!.month, sale.createdAt!.day);
        aggregatedSales.update(
            dayStart, (total) => total + (sale.priceInNaira ?? 0),
            ifAbsent: () => sale.priceInNaira ?? 0);
      }
    }

    final sortedDates = aggregatedSales.keys.toList()..sort();

    final spots = sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final salesAmount = aggregatedSales[date] ?? 0;
      return FlSpot(index.toDouble(), salesAmount);
    }).toList();

    final maxSalesAmount = aggregatedSales.values
        .fold(0.0, (max, amount) => amount > max ? amount : max);
    final maxY = maxSalesAmount > 10000 ? maxSalesAmount * 1.2 : 10000;

    return LineChart(LineChartData(
        minX: 0,
        maxX: spots.length > 1 ? spots.length.toDouble() - 1 : 1,
        minY: 0,
        maxY: maxY.toDouble(),
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots
                .map((barSpot) => LineTooltipItem(
                    '₦${barSpot.y.toStringAsFixed(0)}',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)))
                .toList();
          },
        )),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey[200], strokeWidth: 1),
        ),
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
                      if (value.toInt() >= sortedDates.length ||
                          value.toInt() < 0) return const SizedBox();

                      final date = sortedDates[value.toInt()];
                      String title;

                      switch (filter) {
                        case '1D':
                        case 'Custom':
                          title = DateFormat('ha').format(date);
                          break;
                        case '7D':
                          title = DateFormat('EEE').format(date);
                          break;
                        case '30D':
                          title = DateFormat('d').format(date);
                          break;
                        default:
                          title = '';
                      }
                      return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(title,
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12)));
                    }))),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.black,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.0)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)))
        ]));
  }

  Widget _buildTransactionDataTable(
      List<SalesModel> sales, BuildContext context) {
    final PrintingService service = PrintingService();
    final recentSales = sales.length > 5 ? sales.sublist(0, 5) : sales;

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 16,
        headingTextStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
        dataRowMaxHeight: 60,
        columns: const [
          DataColumn(label: Text('CUSTOMER')),
          DataColumn(label: Text('AMOUNT'), numeric: true),
        ],
        rows: recentSales.map((sale) {
          return DataRow(
            onSelectChanged: (selected) async {
              if (selected ?? false) {
                await service.printReceipt(sale);
              }
            },
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue[50],
                        child: Text(
                          sale.customersName!.split('').first.toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sale.customersName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis),
                          Text(
                              DateFormat('MMM dd, hh:mm a')
                                  .format(sale.createdAt!),
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(currencyFormatter.format(sale.priceInNaira),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _StatItem(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});
}

void _showSettingsDialog(BuildContext dialogContext) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final appProvider = Provider.of<AppProvider>(dialogContext, listen: false);

  if (appProvider.gasBalance != null) {
    priceController.text = appProvider.gasBalance!.priceOfOneKg.toString();
    quantityController.text = appProvider.gasBalance!.quantityKg.toString();
  }

  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Consumer<AppProvider>(builder: (context, provider, child) {
            return StatefulBuilder(
              builder: (dialogContext, setState) {
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Settings',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            IconButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                            'Update the current price and quantity of available gas.'),
                        const SizedBox(height: 24),
                        _buildDialogTextField(
                          controller: priceController,
                          label: 'Price of 1Kg (₦)',
                          hint: 'e.g., 1200',
                          onChanged: (value) => setState(() {}),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Price cannot be empty.';
                            if (double.tryParse(value) == null)
                              return 'Please enter a valid number.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDialogTextField(
                          controller: quantityController,
                          label: 'Available Quantity (Kg)',
                          hint: 'e.g., 50.5',
                          onChanged: (value) => setState(() {}),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Quantity cannot be empty.';
                            if (double.tryParse(value) == null)
                              return 'Please enter a valid number.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        if (priceController.text.isNotEmpty &&
                            quantityController.text.isNotEmpty)
                          Card(
                            color: Colors.grey.shade100,
                            elevation: 0,
                            child: ListTile(
                              title: const Text('Total Gas Value',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text(
                                NumberFormat.currency(
                                        locale: 'en_NG', symbol: '₦')
                                    .format(getTotalPrice(
                                        double.tryParse(priceController.text) ??
                                            0,
                                        double.tryParse(
                                                quantityController.text) ??
                                            0)),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: provider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0))),
                                  onPressed: () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      final price =
                                          double.parse(priceController.text);
                                      final quantity =
                                          double.parse(quantityController.text);
                                      try {
                                        await appProvider.saveBalance(
                                          GasBalanceModel(
                                            totalPrice:
                                                getTotalPrice(price, quantity),
                                            createdAt: appProvider
                                                    .gasBalance?.createdAt ??
                                                DateTime.now(),
                                            updatedAt: DateTime.now(),
                                            priceOfOneKg: price,
                                            quantityKg: quantity,
                                            totalSales: appProvider
                                                    .gasBalance?.totalSales ??
                                                0.0,
                                          ),
                                          docId: appProvider.gasBalance?.id,
                                        );
                                        if (!context.mounted) return;
                                        context.showCustomToast(
                                            message:
                                                "Balance updated successfully");
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        context.showCustomToast(
                                            message: e.toString());
                                      }
                                    }
                                  },
                                  child: const Text('Save Changes',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      );
    },
  );
}

Widget _buildDialogTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required String? Function(String?) validator,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    controller: controller,
    onChanged: onChanged,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );
}

double getTotalPrice(double price, double quantity) {
  return quantity * price;
}
