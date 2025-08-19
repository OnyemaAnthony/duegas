// import 'package:duegas/core/extensions/toast_message.dart';
// import 'package:duegas/core/extensions/ui_extension.dart';
// import 'package:duegas/core/utils/app_router.dart';
// import 'package:duegas/core/utils/logger.dart';
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
//     decimalDigits: 2,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       body: Consumer2<AppProvider, AuthenticationProvider>(
//           builder: (context, provider, authProvider, child) {
//         logger.d(authProvider.user?.toJson());
//         if (provider.isLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return Stack(
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 120.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeader(context),
//                     const SizedBox(height: 30),
//                     _buildSalesCard(provider),
//                     const SizedBox(height: 30),
//                     authProvider.user != null && authProvider.user!.isAdmin!
//                         ? _buildGasBalance(provider)
//                         : buildUserGasBalance(provider),
//                     const SizedBox(height: 30),
//                     provider.sales == null || provider.sales!.isEmpty
//                         ? Center(
//                             child: Text('No recent transactions'),
//                           )
//                         : _buildRecentTransactions(provider, context),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     final userModel =
//         Provider.of<AuthenticationProvider>(context, listen: false);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         RichText(
//           text: TextSpan(
//             style: TextStyle(
//               fontSize: 20,
//               color: Colors.grey,
//               fontFamily: 'SFProDisplay',
//             ),
//             children: [
//               TextSpan(text: 'Welcome '),
//               TextSpan(
//                 text: userModel.user?.name ?? '',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         GestureDetector(
//           onTap: () => _showSettingsDialog(context),
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.settings, color: Colors.black54),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSalesCard(AppProvider provider) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Sales',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 4),
//                   Text('₦${provider.gasBalance?.totalSales ?? 0.0}',
//                       style: TextStyle(color: Colors.white70, fontSize: 16)),
//                 ],
//               ),
//               _buildTimeFilter(),
//             ],
//           ),
//           const SizedBox(height: 30),
//           SizedBox(
//             height: 150,
//             child: _buildLineChart(provider),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeFilter() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade800,
//         borderRadius: BorderRadius.circular(20),
//       ),
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
//       child: Text(
//         text,
//         style: TextStyle(
//           color: isSelected ? Colors.white : Colors.white54,
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLineChart(AppProvider provider) {
//     // Get sales data and group by month
//     final sales = provider.sales ?? [];
//
//     // If no sales data, return an empty container with a message
//     if (sales.isEmpty) {
//       return Center(
//         child: Text(
//           'No sales data available',
//           style: TextStyle(color: Colors.white),
//         ),
//       );
//     }
//
//     final monthlySales = <DateTime, double>{};
//     for (final sale in sales) {
//       final monthStart = DateTime(sale.createdAt!.year, sale.createdAt!.month);
//       monthlySales.update(
//         monthStart,
//         (total) => total + (sale.priceInNaira ?? 0),
//         ifAbsent: () => sale.priceInNaira ?? 0,
//       );
//     }
//
//     // Sort months chronologically
//     final sortedMonths = monthlySales.keys.toList()
//       ..sort((a, b) => a.compareTo(b));
//
//     // Create spots for the chart
//     final spots = sortedMonths.asMap().entries.map((entry) {
//       final index = entry.key;
//       final month = entry.value;
//       final salesAmount = monthlySales[month] ?? 0;
//       return FlSpot(index.toDouble(), salesAmount);
//     }).toList();
//
//     // Find max sales amount for scaling (with minimum of 30,000)
//     final maxSalesAmount = monthlySales.values
//         .fold(0.0, (max, amount) => amount > max ? amount : max);
//     final maxY = maxSalesAmount > 30000 ? maxSalesAmount : 30000;
//
//     return LineChart(
//       LineChartData(
//         minX: 0,
//         maxX: spots.length > 0 ? spots.length - 1 : 0,
//         minY: 0,
//         maxY: maxY.toDouble(),
//         showingTooltipIndicators: spots.isNotEmpty
//             ? [
//                 ShowingTooltipIndicators([
//                   LineBarSpot(
//                     LineChartBarData(spots: spots),
//                     0,
//                     spots.last,
//                   ),
//                 ]),
//               ]
//             : [],
//         lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//             tooltipRoundedRadius: 8,
//             getTooltipItems: (List<LineBarSpot> touchedSpots) {
//               return touchedSpots.map((barSpot) {
//                 return LineTooltipItem(
//                   '₦${barSpot.y.toStringAsFixed(2)}',
//                   const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold),
//                 );
//               }).toList();
//             },
//           ),
//         ),
//         gridData: const FlGridData(show: false),
//         titlesData: FlTitlesData(
//           leftTitles:
//               const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles:
//               const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles:
//               const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 30,
//               interval: 1,
//               getTitlesWidget: (value, meta) {
//                 if (value.toInt() >= sortedMonths.length || value.toInt() < 0) {
//                   return const Text('');
//                 }
//                 final month = sortedMonths[value.toInt()];
//                 final monthName = DateFormat('MMM').format(month);
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     monthName,
//                     style: const TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             color: Colors.white,
//             barWidth: 4,
//             isStrokeCapRound: true,
//             dotData: FlDotData(
//               show: true,
//               getDotPainter: (spot, percent, barData, index) {
//                 if (index == spots.length - 1) {
//                   return FlDotCirclePainter(
//                     radius: 6,
//                     color: Colors.purple.shade200,
//                     strokeWidth: 2,
//                     strokeColor: Colors.white,
//                   );
//                 }
//                 return FlDotCirclePainter(radius: 0);
//               },
//             ),
//             belowBarData: BarAreaData(
//               show: true,
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white.withOpacity(0.3),
//                   Colors.white.withOpacity(0.0),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGasBalance(AppProvider provider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Gas balance',
//               style: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             provider.gasBalance == null
//                 ? Text('No Gas')
//                 : RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         fontSize: 32,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: currencyFormatter.format(
//                             (provider.gasBalance!.totalPrice),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//             RichText(
//               text: TextSpan(
//                 style: TextStyle(
//                   fontSize: 32,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: provider.gasBalance!.quantityKg!.toInt().toString(),
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Kg',
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget buildUserGasBalance(AppProvider provider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Gas balance',
//           style: TextStyle(color: Colors.grey, fontSize: 16),
//         ),
//         const SizedBox(height: 8),
//         provider.gasBalance == null
//             ? Text('No Gas')
//             : RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     fontSize: 32,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: provider.gasBalance!.quantityKg!.toInt().toString(),
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Kg',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ],
//     );
//   }
//
//   Widget _buildRecentTransactions(AppProvider provider, BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text(
//               'Recent Transactions',
//               style: TextStyle(color: Colors.grey, fontSize: 18),
//             ),
//             Spacer(),
//             Text('View all').onClick(() {
//               AppRouter.getPage(
//                 context,
//                 SalesScreen(salesModel: provider.sales!),
//               );
//             }),
//           ],
//         ),
//         _buildTransactionList(provider.sales!),
//       ],
//     );
//   }
//
//   Widget _buildTransactionList(List<SalesModel> sales) {
//     return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: sales.length,
//         itemBuilder: (context, index) {
//           final sale = sales[index];
//           logger.d('message');
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.grey.shade200,
//                   child: Text(sale.customersName!.split('').first),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(sale.customersName!,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16)),
//                       const SizedBox(height: 4),
//                       Text(DateFormat('dd MMMM yyyy').format(sale.createdAt!),
//                           style: const TextStyle(
//                               color: Colors.grey, fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 Text(' ₦${sale.priceInNaira!.toString()}',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16)),
//               ],
//             ),
//           ).onClick(() async {
//             final PrintingService service = PrintingService();
//
//             await service.printReceipt();
//           });
//         });
//   }
// }
//
// void _showSettingsDialog(BuildContext dialogContext) {
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//
//   showDialog(
//     context: dialogContext,
//     builder: (BuildContext context) {
//       return Consumer<AppProvider>(builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return StatefulBuilder(builder: (context, setState) {
//           void attachListeners() {
//             priceController.addListener(() => setState(() {}));
//             quantityController.addListener(() => setState(() {}));
//           }
//
//           attachListeners();
//
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (!priceController.hasListeners) attachListeners();
//           });
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
//
//                   // Input Fields
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
//                         _buildTextField(
//                           priceController,
//                           "Price of (1Kg)",
//                           false,
//                           'Enter price of 1kg in (₦)',
//                         ),
//                         const SizedBox(height: 15),
//                         _buildTextField(
//                           quantityController,
//                           "Quantity",
//                           false,
//                           'Enter Gas in kg',
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 22),
//                   (priceController.text.isNotEmpty &&
//                           quantityController.text.isNotEmpty)
//                       ? Text(
//                           'Price in Naira: ₦${getTotalPrice(
//                             double.tryParse(priceController.text) ?? 0,
//                             double.tryParse(quantityController.text) ?? 0,
//                           ).toStringAsFixed(2)}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         )
//                       : const SizedBox.shrink(),
//
//                   const SizedBox(height: 32),
//
//                   // Submit Button
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
//                         final price = double.tryParse(priceController.text);
//                         final quantity =
//                             double.tryParse(quantityController.text);
//
//                         if (price == null || quantity == null) {
//                           dialogContext.showCustomToast(
//                               message: "Please enter valid numbers");
//                           return;
//                         }
//
//                         try {
//                           await provider.saveBalance(
//                             GasBalanceModel(
//                                 totalPrice: getTotalPrice(price, quantity),
//                                 createdAt: DateTime.now(),
//                                 updatedAt: DateTime.now(),
//                                 priceOfOneKg: price,
//                                 quantityKg: quantity,
//                                 totalSales: 0.0),
//                           );
//
//                           if (!dialogContext.mounted) return;
//
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
//
// //
// // void _showSettingsDialog(BuildContext dialogContext) {
// //   showDialog(
// //     context: dialogContext,
// //     builder: (BuildContext context) {
// //       return Consumer<AppProvider>(builder: (context, provider, child) {
// //         if (provider.isLoading) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //         return StatefulBuilder(builder: (context, setState) {
// //           final TextEditingController quantityController =
// //               TextEditingController();
// //           final TextEditingController priceController = TextEditingController();
// //
// //           return Dialog(
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20.0),
// //             ),
// //             elevation: 0,
// //             backgroundColor: Colors.transparent,
// //             child: Container(
// //               padding: const EdgeInsets.all(24.0),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 shape: BoxShape.rectangle,
// //                 borderRadius: BorderRadius.circular(20.0),
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: <Widget>[
// //                   // Header
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         'Settings',
// //                         style: TextStyle(
// //                             fontSize: 24, fontWeight: FontWeight.bold),
// //                       ),
// //                       InkWell(
// //                         onTap: () => Navigator.of(context).pop(),
// //                         child: Container(
// //                           padding: const EdgeInsets.all(4),
// //                           decoration: BoxDecoration(
// //                             color: Colors.grey.shade300,
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: const Icon(Icons.close, color: Colors.black54),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 32),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 16, vertical: 12),
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey.shade300),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         _buildTextField(quantityController, "Price of (1Kg)",
// //                             false, 'Enter price of 1kg in (₦)'),
// //                         const SizedBox(height: 15),
// //                         _buildTextField(priceController, "Quantity", false,
// //                             'Enter quantity of Gas'),
// //                         const SizedBox(height: 22),
// //                       ],
// //                     ),
// //                   ),
// //                   priceController.text.isNotEmpty &&
// //                           quantityController.text.isNotEmpty
// //                       ? Text(
// //                           'Price in Naira ${getTotalPrice(double.tryParse(priceController.text) ?? 0, double.tryParse(quantityController.text) ?? 0)}')
// //                       : const SizedBox.shrink(),
// //                   const SizedBox(height: 32),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.black,
// //                         padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12.0),
// //                         ),
// //                       ),
// //                       onPressed: () async {
// //                         try {
// //                           await provider.saveBalance(
// //                             GasBalanceModel(
// //                                 totalPrice: getTotalPrice(
// //                                     double.parse(priceController.text),
// //                                     double.parse(quantityController.text)),
// //                                 createdAt: DateTime.now(),
// //                                 updatedAt: DateTime.now(),
// //                                 priceOfOneKg:
// //                                     double.parse(priceController.text),
// //                                 quantityKg:
// //                                     double.parse(quantityController.text)),
// //                           );
// //                           if (!dialogContext.mounted) return;
// //                           dialogContext.showCustomToast(
// //                               message: "Balance set successfully");
// //                           Navigator.of(dialogContext).pop();
// //                         } catch (e) {
// //                           dialogContext.showCustomToast(message: e.toString());
// //                         }
// //                       },
// //                       child: const Text(
// //                         'Save & Continue',
// //                         style: TextStyle(fontSize: 18, color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         });
// //       });
// //     },
// //   );
// // }
//
// double getTotalPrice(double price, double quantity) {
//   return quantity * price;
// }
//
// Widget _buildTextField(TextEditingController controller, String label,
//     bool readOnly, String hint) {
//   return TextField(
//     controller: controller,
//     readOnly: readOnly,
//     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//     decoration: InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.black, width: 1.5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//   );
// }

// import 'package:duegas/core/extensions/ui_extension.dart'; // Replaced with standard widgets
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
          if (provider.isLoading || authProvider.user == null) {
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

  // --- RESPONSIVE LAYOUTS ---

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
              child: _buildSalesCard(provider),
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
        _buildSalesCard(provider),
        const SizedBox(height: 24),
        authProvider.user!.isAdmin!
            ? _buildGasBalanceCard(provider)
            : _buildUserGasBalanceCard(provider),
        const SizedBox(height: 24),
        _buildRecentTransactionsCard(provider, context),
      ],
    );
  }

  // --- WIDGETS (REUSED BY BOTH LAYOUTS) ---

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

  Widget _buildSalesCard(AppProvider provider) {
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
                        currencyFormatter
                            .format(provider.gasBalance?.totalSales ?? 0.0),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                _buildTimeFilter(),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(height: 150, child: _buildLineChart(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
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
      child: Text(text,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildLineChart(AppProvider provider) {
    final sales = provider.sales ?? [];
    if (sales.isEmpty) {
      return const Center(
          child: Text('No sales data to display',
              style: TextStyle(color: Colors.white54)));
    }
    final monthlySales = <DateTime, double>{};
    for (final sale in sales) {
      final monthStart = DateTime(sale.createdAt!.year, sale.createdAt!.month);
      monthlySales.update(
          monthStart, (total) => total + (sale.priceInNaira ?? 0),
          ifAbsent: () => sale.priceInNaira ?? 0);
    }
    final sortedMonths = monthlySales.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    final spots = sortedMonths.asMap().entries.map((entry) {
      final index = entry.key;
      final month = entry.value;
      final salesAmount = monthlySales[month] ?? 0;
      return FlSpot(index.toDouble(), salesAmount);
    }).toList();
    final maxSalesAmount = monthlySales.values
        .fold(0.0, (max, amount) => amount > max ? amount : max);
    final maxY = maxSalesAmount > 30000 ? maxSalesAmount : 30000;
    return LineChart(LineChartData(
        minX: 0,
        maxX: spots.length > 1 ? spots.length - 1 : 1,
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
                      if (value.toInt() >= sortedMonths.length ||
                          value.toInt() < 0) return const SizedBox();
                      final month = sortedMonths[value.toInt()];
                      return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(DateFormat('MMM').format(month),
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
                      context, SalesScreen(salesModel: provider.sales!)),
                  child: const Text('View all',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider.sales == null || provider.sales!.isEmpty)
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No transactions yet.')))
            else
              _buildTransactionDataTable(provider.sales!, context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDataTable(
      List<SalesModel> sales, BuildContext context) {
    final PrintingService service = PrintingService();
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
              await service.printReceipt(sale);
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
            if (appProvider.isLoading) {
              return SizedBox.shrink();
            }
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                final price = int.parse(priceController.text);
                                final quantity =
                                    int.parse(quantityController.text);
                                try {
                                  await appProvider.saveBalance(
                                    GasBalanceModel(
                                      totalPrice: getTotalPrice(
                                          price.toDouble(),
                                          quantity.toDouble()),
                                      createdAt:
                                          appProvider.gasBalance?.createdAt ??
                                              DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      priceOfOneKg: price.toDouble(),
                                      quantityKg: quantity.toDouble(),
                                      totalSales:
                                          appProvider.gasBalance?.totalSales ??
                                              0.0, // Preserve total sales
                                    ),
                                  );
                                  if (!context.mounted) return;
                                  context.showCustomToast(
                                      message: "Balance updated successfully");
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

// void _showSettingsDialog(BuildContext dialogContext) {
//   final formKey = GlobalKey<FormState>();
//   final appProvider = Provider.of<AppProvider>(dialogContext, listen: false);
//
//   final newPricePerKgController = TextEditingController();
//   final quantityToAddController = TextEditingController();
//   final totalCostController = TextEditingController();
//
//   final currentBalance = appProvider.gasBalance;
//   final currentPricePerKg = currentBalance?.priceOfOneKg ?? 0;
//   if (currentPricePerKg > 0) {
//     newPricePerKgController.text = currentPricePerKg.toStringAsFixed(2);
//   }
//
//   showDialog(
//     context: dialogContext,
//     builder: (BuildContext context) {
//       bool _isUpdating = false;
//
//       return Dialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 500),
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               void _updateTotalCost() {
//                 if (_isUpdating) return;
//                 final quantity =
//                     double.tryParse(quantityToAddController.text) ?? 0;
//                 final price =
//                     double.tryParse(newPricePerKgController.text) ?? 0;
//                 _isUpdating = true;
//                 totalCostController.text =
//                     (quantity * price).toStringAsFixed(2);
//                 _isUpdating = false;
//               }
//
//               void _updateQuantity() {
//                 if (_isUpdating) return;
//                 final totalCost =
//                     double.tryParse(totalCostController.text) ?? 0;
//                 final price =
//                     double.tryParse(newPricePerKgController.text) ?? 0;
//                 _isUpdating = true;
//                 quantityToAddController.text =
//                     (price > 0 ? totalCost / price : 0).toStringAsFixed(2);
//                 _isUpdating = false;
//               }
//
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (!quantityToAddController.hasListeners) {
//                   quantityToAddController.addListener(() {
//                     _updateTotalCost();
//                     setState(() {});
//                   });
//                 }
//                 if (!totalCostController.hasListeners) {
//                   totalCostController.addListener(() {
//                     _updateQuantity();
//                     setState(() {});
//                   });
//                 }
//                 if (!newPricePerKgController.hasListeners) {
//                   newPricePerKgController.addListener(() {
//                     _updateTotalCost();
//                     setState(() {});
//                   });
//                 }
//               });
//
//               final double currentQty = currentBalance?.quantityKg ?? 0;
//               final double qtyToAdd =
//                   double.tryParse(quantityToAddController.text) ?? 0;
//               final double newTotalQty = currentQty + qtyToAdd;
//               final double newPrice =
//                   double.tryParse(newPricePerKgController.text) ??
//                       currentPricePerKg;
//               final double newTotalValue = newTotalQty * newPrice;
//
//               return Form(
//                 key: formKey,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Update Gas Balance',
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold)),
//                           IconButton(
//                               onPressed: () => Navigator.of(context).pop(),
//                               icon: const Icon(Icons.close)),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildInfoCard(
//                         'Current Balance',
//                         '${currentBalance?.quantityKg?.toStringAsFixed(2) ?? '0.00'} Kg',
//                         'Value: ${NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(currentBalance?.totalPrice ?? 0)}',
//                       ),
//                       const Divider(height: 32),
//                       const Text('Add New Purchase',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       _buildDialogTextField(
//                         controller: newPricePerKgController,
//                         label: 'New Price per Kg (₦)',
//                         hint: 'Enter the cost for 1Kg of gas',
//                         validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
//                             ? 'Price must be positive'
//                             : null,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDialogTextField(
//                         controller: quantityToAddController,
//                         label: 'Quantity to Add (Kg)',
//                         hint: 'Enter kg of gas bought',
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDialogTextField(
//                         controller: totalCostController,
//                         label: 'Total Cost of Purchase (₦)',
//                         hint: 'Enter total amount paid',
//                       ),
//                       const SizedBox(height: 24),
//                       _buildInfoCard(
//                         'New Balance Preview',
//                         '${newTotalQty.toStringAsFixed(2)} Kg',
//                         'New Value: ${NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(newTotalValue)}',
//                         isSuccess: true,
//                       ),
//                       const SizedBox(height: 32),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 16.0),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12.0))),
//                           onPressed: () async {
//                             if (formKey.currentState!.validate()) {
//                               final double addedQuantity = double.tryParse(
//                                       quantityToAddController.text) ??
//                                   0;
//                               if (addedQuantity <= 0) {
//                                 dialogContext.showCustomToast(
//                                     message:
//                                         "Please enter a quantity or cost to add.");
//                                 return;
//                               }
//
//                               try {
//                                 logger.d('messstarrtsage');
//
//                                 await appProvider.saveBalance(
//                                   GasBalanceModel(
//                                     totalPrice: newTotalValue,
//                                     createdAt: currentBalance?.createdAt ??
//                                         DateTime.now(),
//                                     updatedAt: DateTime.now(),
//                                     priceOfOneKg: newPrice,
//                                     quantityKg: newTotalQty,
//                                     totalSales:
//                                         currentBalance?.totalSales ?? 0.0,
//                                   ),
//                                 );
//                                 if (!dialogContext.mounted) return;
//                                 dialogContext.showCustomToast(
//                                     message: "Balance updated successfully");
//                                 Navigator.of(dialogContext).pop();
//                               } catch (e) {
//                                 dialogContext.showCustomToast(
//                                     message: e.toString());
//                               }
//                             }
//                           },
//                           child: const Text('Confirm & Save',
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     },
//   );
// }

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

// Widget _buildDialogTextField({
//   required TextEditingController controller,
//   required String label,
//   required String hint,
//   String? Function(String?)? validator,
// }) {
//   return TextFormField(
//     controller: controller,
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

Widget _buildInfoCard(String title, String data, String subtitle,
    {bool isSuccess = false}) {
  return Card(
    color: isSuccess ? Colors.green.shade50 : Colors.grey.shade100,
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: isSuccess ? Colors.green.shade200 : Colors.grey.shade200)),
    child: ListTile(
      title: Text(title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      trailing: Text(
        data,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSuccess ? Colors.green.shade800 : Colors.black),
      ),
    ),
  );
}

double getTotalPrice(double price, double quantity) {
  return quantity * price;
}
