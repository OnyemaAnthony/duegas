import 'package:duegas/features/app/model/sales_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesScreen extends StatelessWidget {
  final List<SalesModel> salesModel;

  const SalesScreen({super.key, required this.salesModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last 20 sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: salesModel.isEmpty
            ? Center(
                child: Text('No sales'),
              )
            : _buildTransactionList(salesModel),
      ),
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
