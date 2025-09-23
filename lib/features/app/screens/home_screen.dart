// import 'package:duegas/core/extensions/toast_message.dart';
// import 'package:duegas/core/utils/app_router.dart';
// import 'package:duegas/features/app/app_provider.dart';
// import 'package:duegas/features/app/model/gas_balance_model.dart';
// import 'package:duegas/features/app/model/sales_model.dart';
// import 'package:duegas/features/app/screens/sales_screen.dart';
// import 'package:duegas/features/auth/auth_provider.dart';
// import 'package:duegas/features/widgets/printing_service.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class DashboardScreen extends StatelessWidget {
//   DashboardScreen({super.key});
//
//   final currencyFormatter = NumberFormat.currency(
//     locale: 'en_NG',
//     symbol: '₦',
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       body: Consumer2<AppProvider, AuthenticationProvider>(
//         builder: (context, provider, authProvider, child) {
//           if (provider.isLoading || authProvider.user == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 1400),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24.0),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     if (constraints.maxWidth > 960) {
//                       return _buildWideLayout(context, provider, authProvider);
//                     } else {
//                       return _buildNarrowLayout(
//                           context, provider, authProvider);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   /// Layout for wide screens (desktops)
//   Widget _buildWideLayout(BuildContext context, AppProvider provider,
//       AuthenticationProvider authProvider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildHeader(context, authProvider),
//         const SizedBox(height: 24),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 2,
//               child: _buildSalesCard(provider),
//             ),
//             const SizedBox(width: 24),
//             Expanded(
//               flex: 1,
//               child: Column(
//                 children: [
//                   authProvider.user!.isAdmin!
//                       ? _buildGasBalanceCard(provider)
//                       : _buildUserGasBalanceCard(provider),
//                   const SizedBox(height: 24),
//                   _buildRecentTransactionsCard(provider, context),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   /// Layout for narrow screens (mobile)
//   Widget _buildNarrowLayout(BuildContext context, AppProvider provider,
//       AuthenticationProvider authProvider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildHeader(context, authProvider),
//         const SizedBox(height: 24),
//         _buildSalesCard(provider),
//         const SizedBox(height: 24),
//         authProvider.user!.isAdmin!
//             ? _buildGasBalanceCard(provider)
//             : _buildUserGasBalanceCard(provider),
//         const SizedBox(height: 24),
//         _buildRecentTransactionsCard(provider, context),
//       ],
//     );
//   }
//
//   Widget _buildHeader(
//       BuildContext context, AuthenticationProvider authProvider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         RichText(
//           text: TextSpan(
//             style: const TextStyle(
//                 fontSize: 24, color: Colors.grey, fontFamily: 'SFProDisplay'),
//             children: [
//               const TextSpan(text: 'Welcome, '),
//               TextSpan(
//                 text: authProvider.user?.name ?? '',
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.black),
//               ),
//             ],
//           ),
//         ),
//         Tooltip(
//           message: 'Settings',
//           child: IconButton(
//             onPressed: () {
//               if (!authProvider.user!.isAdmin!) {
//                 return context.showCustomToast(
//                     message: 'Please contact the Admin');
//               }
//               _showSettingsDialog(context);
//             },
//             icon: const Icon(Icons.settings_outlined, color: Colors.black54),
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSalesCard(AppProvider provider) {
//     return Card(
//       color: Colors.black,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Total Sales',
//                         style: TextStyle(color: Colors.white70, fontSize: 16)),
//                     const SizedBox(height: 8),
//                     Text(
//                         currencyFormatter
//                             .format(provider.gasBalance?.totalSales ?? 0.0),
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 _buildTimeFilter(),
//               ],
//             ),
//             const SizedBox(height: 30),
//             SizedBox(height: 150, child: _buildLineChart(provider)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimeFilter() {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           _buildFilterButton('1D', isSelected: true),
//           _buildFilterButton('7D'),
//           _buildFilterButton('30D'),
//           _buildFilterButton('1Y'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterButton(String text, {bool isSelected = false}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.grey.shade600 : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(text,
//           style: TextStyle(
//               color: isSelected ? Colors.white : Colors.white54,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
//     );
//   }
//
//   Widget _buildLineChart(AppProvider provider) {
//     final sales = provider.sales ?? [];
//     if (sales.isEmpty) {
//       return const Center(
//           child: Text('No sales data to display',
//               style: TextStyle(color: Colors.white54)));
//     }
//     final monthlySales = <DateTime, double>{};
//     for (final sale in sales) {
//       final monthStart = DateTime(sale.createdAt!.year, sale.createdAt!.month);
//       monthlySales.update(
//           monthStart, (total) => total + (sale.priceInNaira ?? 0),
//           ifAbsent: () => sale.priceInNaira ?? 0);
//     }
//     final sortedMonths = monthlySales.keys.toList()
//       ..sort((a, b) => a.compareTo(b));
//     final spots = sortedMonths.asMap().entries.map((entry) {
//       final index = entry.key;
//       final month = entry.value;
//       final salesAmount = monthlySales[month] ?? 0;
//       return FlSpot(index.toDouble(), salesAmount);
//     }).toList();
//     final maxSalesAmount = monthlySales.values
//         .fold(0.0, (max, amount) => amount > max ? amount : max);
//     final maxY = maxSalesAmount > 30000 ? maxSalesAmount : 30000;
//     return LineChart(LineChartData(
//         minX: 0,
//         maxX: spots.length > 1 ? spots.length - 1 : 1,
//         minY: 0,
//         maxY: maxY.toDouble(),
//         lineTouchData: LineTouchData(touchTooltipData:
//             LineTouchTooltipData(getTooltipItems: (touchedSpots) {
//           return touchedSpots
//               .map((barSpot) => LineTooltipItem(
//                   '₦${barSpot.y.toStringAsFixed(0)}',
//                   const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)))
//               .toList();
//         })),
//         gridData: const FlGridData(show: false),
//         titlesData: FlTitlesData(
//             leftTitles:
//                 const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             rightTitles:
//                 const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             topTitles:
//                 const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 30,
//                     interval: 1,
//                     getTitlesWidget: (value, meta) {
//                       if (value.toInt() >= sortedMonths.length ||
//                           value.toInt() < 0) return const SizedBox();
//                       final month = sortedMonths[value.toInt()];
//                       return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(DateFormat('MMM').format(month),
//                               style: const TextStyle(
//                                   color: Colors.white54, fontSize: 12)));
//                     }))),
//         borderData: FlBorderData(show: false),
//         lineBarsData: [
//           LineChartBarData(
//               spots: spots,
//               isCurved: true,
//               color: Colors.white,
//               barWidth: 4,
//               isStrokeCapRound: true,
//               dotData: const FlDotData(show: false),
//               belowBarData: BarAreaData(
//                   show: true,
//                   gradient: LinearGradient(colors: [
//                     Colors.white.withOpacity(0.3),
//                     Colors.white.withOpacity(0.0)
//                   ], begin: Alignment.topCenter, end: Alignment.bottomCenter)))
//         ]));
//   }
//
//   Widget _buildGasBalanceCard(AppProvider provider) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Gas Balance',
//                 style: TextStyle(color: Colors.grey, fontSize: 16)),
//             const SizedBox(height: 8),
//             if (provider.gasBalance == null)
//               const Text('Not Set',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
//             else
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Text(
//                     '${provider.gasBalance!.quantityKg!.toStringAsFixed(1)} ',
//                     style: const TextStyle(
//                         fontSize: 32,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const Text('Kg',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             const SizedBox(height: 4),
//             Text(
//               'Value: ${currencyFormatter.format(provider.gasBalance?.totalPrice ?? 0)}',
//               style: const TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserGasBalanceCard(AppProvider provider) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Gas Balance',
//                 style: TextStyle(color: Colors.grey, fontSize: 16)),
//             const SizedBox(height: 8),
//             if (provider.gasBalance == null)
//               const Text('Not Set',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
//             else
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Text(
//                       '${provider.gasBalance!.quantityKg!.toStringAsFixed(1)} ',
//                       style: const TextStyle(
//                           fontSize: 32, fontWeight: FontWeight.bold)),
//                   const Text('Kg',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold)),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecentTransactionsCard(
//       AppProvider provider, BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Recent Transactions',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 TextButton(
//                   onPressed: () => AppRouter.getPage(
//                       context, SalesScreen(salesModel: provider.sales!)),
//                   child: const Text('View all',
//                       style: TextStyle(color: Colors.black)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             if (provider.sales == null || provider.sales!.isEmpty)
//               const Center(
//                   child: Padding(
//                       padding: EdgeInsets.all(32.0),
//                       child: Text('No transactions yet.')))
//             else
//               _buildTransactionDataTable(provider.sales!, context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTransactionDataTable(
//       List<SalesModel> sales, BuildContext context) {
//     final PrintingService service = PrintingService();
//     final recentSales = sales.length > 5 ? sales.sublist(0, 5) : sales;
//
//     return SizedBox(
//       width: double.infinity,
//       child: DataTable(
//         columnSpacing: 16,
//         columns: const [
//           DataColumn(label: Text('Customer')),
//           DataColumn(label: Text('Amount'), numeric: true),
//         ],
//         rows: recentSales.map((sale) {
//           return DataRow(
//             onSelectChanged: (selected) async {
//               await service.printReceipt(sale);
//             },
//             cells: [
//               DataCell(
//                 Row(
//                   children: [
//                     CircleAvatar(
//                         radius: 18,
//                         backgroundColor: Colors.grey.shade200,
//                         child: Text(
//                             sale.customersName!.split('').first.toUpperCase())),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(sale.customersName!,
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                               overflow: TextOverflow.ellipsis),
//                           Text(
//                               DateFormat('dd MMM yyyy').format(sale.createdAt!),
//                               style: const TextStyle(
//                                   color: Colors.grey, fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               DataCell(Text(currencyFormatter.format(sale.priceInNaira),
//                   style: const TextStyle(fontWeight: FontWeight.bold))),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// void _showSettingsDialog(BuildContext dialogContext) {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final appProvider = Provider.of<AppProvider>(dialogContext, listen: false);
//
//   if (appProvider.gasBalance != null) {
//     priceController.text = appProvider.gasBalance!.priceOfOneKg.toString();
//     quantityController.text = appProvider.gasBalance!.quantityKg.toString();
//   }
//
//   showDialog(
//     context: dialogContext,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 500),
//           child: Consumer<AppProvider>(builder: (context, provider, child) {
//             if (appProvider.isLoading) {
//               return SizedBox.shrink();
//             }
//             return StatefulBuilder(
//               builder: (dialogContext, setState) {
//                 return Form(
//                   key: formKey,
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('Settings',
//                                 style: TextStyle(
//                                     fontSize: 24, fontWeight: FontWeight.bold)),
//                             IconButton(
//                                 onPressed: () =>
//                                     Navigator.of(dialogContext).pop(),
//                                 icon: const Icon(Icons.close)),
//                           ],
//                         ),
//                         const SizedBox(height: 24),
//                         const Text(
//                             'Update the current price and quantity of available gas.'),
//                         const SizedBox(height: 24),
//                         _buildDialogTextField(
//                           controller: priceController,
//                           label: 'Price of 1Kg (₦)',
//                           hint: 'e.g., 1200',
//                           onChanged: (value) => setState(() {}),
//                           validator: (value) {
//                             if (value == null || value.isEmpty)
//                               return 'Price cannot be empty.';
//                             if (double.tryParse(value) == null)
//                               return 'Please enter a valid number.';
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDialogTextField(
//                           controller: quantityController,
//                           label: 'Available Quantity (Kg)',
//                           hint: 'e.g., 50.5',
//                           onChanged: (value) => setState(() {}),
//                           validator: (value) {
//                             if (value == null || value.isEmpty)
//                               return 'Quantity cannot be empty.';
//                             if (double.tryParse(value) == null)
//                               return 'Please enter a valid number.';
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 24),
//                         if (priceController.text.isNotEmpty &&
//                             quantityController.text.isNotEmpty)
//                           Card(
//                             color: Colors.grey.shade100,
//                             elevation: 0,
//                             child: ListTile(
//                               title: const Text('Total Gas Value',
//                                   style:
//                                       TextStyle(fontWeight: FontWeight.bold)),
//                               trailing: Text(
//                                 NumberFormat.currency(
//                                         locale: 'en_NG', symbol: '₦')
//                                     .format(getTotalPrice(
//                                         double.tryParse(priceController.text) ??
//                                             0,
//                                         double.tryParse(
//                                                 quantityController.text) ??
//                                             0)),
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         const SizedBox(height: 32),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.black,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16.0),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12.0))),
//                             onPressed: () async {
//                               if (formKey.currentState?.validate() ?? false) {
//                                 final price = int.parse(priceController.text);
//                                 final quantity =
//                                     int.parse(quantityController.text);
//                                 try {
//                                   await appProvider.saveBalance(
//                                     GasBalanceModel(
//                                       totalPrice: getTotalPrice(
//                                           price.toDouble(),
//                                           quantity.toDouble()),
//                                       createdAt:
//                                           appProvider.gasBalance?.createdAt ??
//                                               DateTime.now(),
//                                       updatedAt: DateTime.now(),
//                                       priceOfOneKg: price.toDouble(),
//                                       quantityKg: quantity.toDouble(),
//                                       totalSales:
//                                           appProvider.gasBalance?.totalSales ??
//                                               0.0, // Preserve total sales
//                                     ),
//                                   );
//                                   if (!context.mounted) return;
//                                   context.showCustomToast(
//                                       message: "Balance updated successfully");
//                                   Navigator.of(context).pop();
//                                 } catch (e) {
//                                   context.showCustomToast(
//                                       message: e.toString());
//                                 }
//                               }
//                             },
//                             child: const Text('Save Changes',
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ),
//       );
//     },
//   );
// }
//
// Widget _buildDialogTextField({
//   required TextEditingController controller,
//   required String label,
//   required String hint,
//   required String? Function(String?) validator,
//   void Function(String)? onChanged,
// }) {
//   return TextFormField(
//     controller: controller,
//     onChanged: onChanged,
//     validator: validator,
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//     decoration: InputDecoration(
//       labelText: label,
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//     ),
//   );
// }
//
// double getTotalPrice(double price, double quantity) {
//   return quantity * price;
// }

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
                    if (constraints.maxWidth > 960) {
                      return _buildWideLayout(context, provider, authProvider);
                    } else {
                      return _buildNarrowLayout(
                          context, provider, authProvider);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Layout for wide screens (desktops)
  Widget _buildWideLayout(BuildContext context, AppProvider provider,
      AuthenticationProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, authProvider),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildSalesCard(context, provider),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  authProvider.user!.isAdmin!
                      ? _buildGasBalanceCard(provider)
                      : _buildUserGasBalanceCard(provider),
                  const SizedBox(height: 24),
                  _buildRecentTransactionsCard(provider, context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Layout for narrow screens (mobile)
  Widget _buildNarrowLayout(BuildContext context, AppProvider provider,
      AuthenticationProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, authProvider),
        const SizedBox(height: 24),
        _buildSalesCard(context, provider),
        const SizedBox(height: 24),
        authProvider.user!.isAdmin!
            ? _buildGasBalanceCard(provider)
            : _buildUserGasBalanceCard(provider),
        const SizedBox(height: 24),
        _buildRecentTransactionsCard(provider, context),
      ],
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
        Tooltip(
          message: 'Settings',
          child: IconButton(
            onPressed: () {
              if (!authProvider.user!.isAdmin!) {
                return context.showCustomToast(
                    message: 'Please contact the Admin');
              }
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

  Widget _buildSalesCard(BuildContext context, AppProvider provider) {
    return Card(
      color: Colors.black,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Sales',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                        currencyFormatter.format(
                            provider.totalFilteredSales), // Use filtered total
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                _buildTimeFilter(context, provider),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(height: 150, child: _buildLineChart(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter(BuildContext context, AppProvider provider) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
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
          color: isSelected ? Colors.grey.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
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
          color: isSelected ? Colors.grey.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 14, color: isSelected ? Colors.white : Colors.white54),
            const SizedBox(width: 4),
            Text(
              isSelected && provider.customDate != null
                  ? DateFormat('MMM d').format(provider.customDate!)
                  : 'Date',
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
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
              style: TextStyle(color: Colors.white54)));
    }

    final Map<DateTime, double> aggregatedSales = {};
    final String filter = provider.selectedFilter;

    // Aggregate sales data based on the selected filter
    if (filter == '1D' || filter == 'Custom') {
      // Aggregate by hour
      for (final sale in sales) {
        final hourStart = DateTime(sale.createdAt!.year, sale.createdAt!.month,
            sale.createdAt!.day, sale.createdAt!.hour);
        aggregatedSales.update(
            hourStart, (total) => total + (sale.priceInNaira ?? 0),
            ifAbsent: () => sale.priceInNaira ?? 0);
      }
    } else {
      // Aggregate by day for '7D' and '30D'
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
        lineTouchData: LineTouchData(touchTooltipData:
            LineTouchTooltipData(getTooltipItems: (touchedSpots) {
          return touchedSpots
              .map((barSpot) => LineTooltipItem(
                  '₦${barSpot.y.toStringAsFixed(0)}',
                  const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)))
              .toList();
        })),
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
                      if (value.toInt() >= sortedDates.length ||
                          value.toInt() < 0) return const SizedBox();

                      final date = sortedDates[value.toInt()];
                      String title;

                      switch (filter) {
                        case '1D':
                        case 'Custom':
                          title = DateFormat('ha').format(date); // e.g., 6AM
                          break;
                        case '7D':
                          title = DateFormat('EEE').format(date); // e.g., Mon
                          break;
                        case '30D':
                          title = DateFormat('d').format(date); // e.g., 15
                          break;
                        default:
                          title = '';
                      }
                      return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(title,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12)));
                    }))),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.white,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.0)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)))
        ]));
  }

  Widget _buildGasBalanceCard(AppProvider provider) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gas Balance',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 8),
            if (provider.gasBalance == null)
              const Text('Not Set',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${provider.gasBalance!.quantityKg!.toStringAsFixed(1)} ',
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text('Kg',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            const SizedBox(height: 4),
            Text(
              'Value: ${currencyFormatter.format(provider.gasBalance?.totalPrice ?? 0)}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserGasBalanceCard(AppProvider provider) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gas Balance',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 8),
            if (provider.gasBalance == null)
              const Text('Not Set',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                      '${provider.gasBalance!.quantityKg!.toStringAsFixed(1)} ',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  const Text('Kg',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildTransactionDataTable(
      List<SalesModel> sales, BuildContext context) {
    final PrintingService service = PrintingService();
    // Use the paginated 'sales' list for recent transactions
    final recentSales = sales.length > 5 ? sales.sublist(0, 5) : sales;

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 16,
        columns: const [
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Amount'), numeric: true),
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
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                            sale.customersName!.split('').first.toUpperCase())),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sale.customersName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                          Text(
                              DateFormat('dd MMM yyyy').format(sale.createdAt!),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(currencyFormatter.format(sale.priceInNaira),
                  style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          );
        }).toList(),
      ),
    );
  }
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
