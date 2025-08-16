import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double receiptWidth = 300.0;

    return Container(
      width: receiptWidth,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Sales Receipt',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Due gas Limited',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Abia state '),
            Text('Tel: 09084904'),
            const SizedBox(height: 16),
            const Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Receipt No: 100'),
                Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
              ],
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),

            // Customer Information
            if (true)
              const Chip(
                label: Text('First-Time Customer Discount Applied'),
                backgroundColor: Colors.amberAccent,
              ),

            const SizedBox(height: 20),

            // Items Table
            _buildItemRow('Item', 'Qty (kg)', 'Price'),
            const Divider(thickness: 1.5, color: Colors.black),
            _buildItemRow('Product Sale', 20.toString(), '1000'),
            const Divider(thickness: 1.5, color: Colors.black),
            const SizedBox(height: 10),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Total: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '1000',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Thanks for the patronage!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String item, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: Text(item,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text(qty, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(price, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
