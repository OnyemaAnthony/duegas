// import 'package:duegas/features/app/model/sales_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class SalesScreen extends StatelessWidget {
//   final List<SalesModel> salesModel;
//
//   const SalesScreen({super.key, required this.salesModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Last 20 sales'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: salesModel.isEmpty
//             ? Center(
//                 child: Text('No sales'),
//               )
//             : _buildTransactionList(salesModel),
//       ),
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
//           );
//         });
//   }
// }

import 'package:duegas/features/app/model/sales_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Converted to a StatefulWidget to handle search, filtering, and sorting
class SalesScreen extends StatefulWidget {
  final List<SalesModel> salesModel;

  const SalesScreen({super.key, required this.salesModel});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<SalesModel> _filteredSales;
  int _sortColumnIndex = 1; // Default sort by Date (index 1)
  bool _isAscending = false; // Default to descending (most recent first)

  @override
  void initState() {
    super.initState();
    _filteredSales = List.from(widget.salesModel);
    _sortSales(); // Perform initial sort
    _searchController.addListener(_filterSales);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSales);
    _searchController.dispose();
    super.dispose();
  }

  void _filterSales() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSales = widget.salesModel.where((sale) {
        return sale.customersName?.toLowerCase().contains(query) ?? false;
      }).toList();
      _sortSales(); // Re-apply sort after filtering
    });
  }

  void _sortSales() {
    _filteredSales.sort((a, b) {
      int comparison;
      switch (_sortColumnIndex) {
        case 2: // Quantity
          comparison = (a.quantityInKg ?? 0).compareTo(b.quantityInKg ?? 0);
          break;
        case 3: // Amount
          comparison = (a.priceInNaira ?? 0).compareTo(b.priceInNaira ?? 0);
          break;
        case 1: // Date (default)
        default:
          comparison = (a.createdAt ?? DateTime(0))
              .compareTo(b.createdAt ?? DateTime(0));
          break;
      }
      return _isAscending ? comparison : -comparison;
    });
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
      _sortSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('All Sales'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by customer name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
                    child: _filteredSales.isEmpty
                        ? _buildEmptyState()
                        : _buildSalesDataTable(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No Sales Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'There are no sales records to display.'
                : 'No sales match your search.',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSalesDataTable() {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _isAscending,
        columnSpacing: 20,
        columns: [
          const DataColumn(
              label: Text('Customer',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: const Text('Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: _onSort),
          DataColumn(
              label: const Text('Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
              onSort: _onSort),
          DataColumn(
              label: const Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
              onSort: _onSort),
        ],
        rows: _filteredSales.map((sale) {
          return DataRow(
            cells: [
              // Customer Cell
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                          sale.customersName!.split('').first.toUpperCase()),
                    ),
                    const SizedBox(width: 12),
                    Text(sale.customersName!),
                  ],
                ),
              ),
              // Date Cell
              DataCell(Text(DateFormat('dd MMM yyyy').format(sale.createdAt!))),
              // Quantity Cell
              DataCell(Text(
                  '${sale.quantityInKg?.toStringAsFixed(2) ?? '0.00'} Kg')),
              // Amount Cell
              DataCell(Text(currencyFormatter.format(sale.priceInNaira ?? 0))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
