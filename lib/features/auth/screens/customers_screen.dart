import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CustomerModel> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _filteredCustomers = provider.customers ?? [];
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCustomers() {
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final allCustomers = provider.customers ?? [];
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredCustomers = allCustomers;
      });
    } else {
      setState(() {
        _filteredCustomers = allCustomers.where((customer) {
          final nameMatches =
              customer.name?.toLowerCase().contains(query) ?? false;
          final phoneMatches =
              customer.phoneNumber?.toLowerCase().contains(query) ?? false;
          return nameMatches || phoneMatches;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Select Customer'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body:
          Consumer<AuthenticationProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone number...',
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

                  // --- Customer List or Empty State ---
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip
                          .antiAlias, // Ensures the DataTable respects the border radius
                      child: _filteredCustomers.isEmpty
                          ? _buildEmptyState()
                          : _buildCustomerDataTable(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No Customers Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'You have not added any customers yet.'
                : 'No customers match your search.',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDataTable() {
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(
              label: Text('Customer',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Phone Number',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Join Date',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _filteredCustomers.map((customer) {
          return DataRow(
            onSelectChanged: (isSelected) {
              if (isSelected ?? false) {
                Navigator.of(context).pop(customer);
              }
            },
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Text(customer.name!.split('').first.toUpperCase()),
                    ),
                    const SizedBox(width: 12),
                    Text(customer.name!),
                  ],
                ),
              ),
              // Phone Cell
              DataCell(
                Text(customer.phoneNumber ?? 'N/A'),
              ),
              // Join Date Cell
              DataCell(
                Text(DateFormat('dd MMM yyyy').format(customer.createdAt!)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
