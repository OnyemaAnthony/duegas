import 'dart:async';
import 'package:duegas/features/auth/auth_provider.dart';
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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getCustomers(refresh: true);
    });

    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.getMoreCustomers();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final provider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      provider.getCustomers(query: _searchController.text, refresh: true);
    });
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
                      hintText: 'Search by name...',
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
                      clipBehavior: Clip.antiAlias,
                      child: (provider.isLoading &&
                              (provider.customers == null ||
                                  provider.customers!.isEmpty))
                          ? const Center(child: CircularProgressIndicator())
                          : (provider.customers == null ||
                                  provider.customers!.isEmpty)
                              ? _buildEmptyState()
                              : _buildCustomerList(provider),
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

  Widget _buildCustomerList(AuthenticationProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          provider.customers!.length + (provider.hasMoreCustomers ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.customers!.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final customer = provider.customers![index];
        return Column(
          children: [
            ListTile(
              onTap: () => Navigator.of(context).pop(customer),
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: Text(customer.name!.split('').first.toUpperCase()),
              ),
              title: Text(customer.name!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(customer.phoneNumber ?? 'N/A'),
              trailing: Text(
                  DateFormat('dd MMM yyyy').format(customer.createdAt!),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ),
            const Divider(height: 1, indent: 70),
          ],
        );
      },
    );
  }
}
