import 'dart:async';
import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/core/utils/redemption_dialog.dart';
import 'package:duegas/features/app/screens/customer_details_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:duegas/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    // Initial fetch, reusing the same logic as CustomersScreen
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

  CustomerModel? _selectedCustomer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:
          Consumer<AuthenticationProvider>(builder: (context, provider, child) {
        if (provider.isLoading &&
            (provider.customers == null || provider.customers!.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null &&
            (provider.customers == null || provider.customers!.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error loading customers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    provider.getCustomers(refresh: true);
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        return LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // LEFT PANEL: List
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    _buildUserInfoHeader(context),
                                    const Divider(height: 32),
                                    _buildSearchBar(context),
                                    const SizedBox(height: 16),
                                    if (provider.customers == null ||
                                        provider.customers!.isEmpty)
                                      Expanded(child: _buildEmptyState())
                                    else
                                      Expanded(
                                          child: _buildCustomerList(
                                              context, provider, true)),
                                  ],
                                ),
                              ),
                              const VerticalDivider(width: 32, thickness: 1),
                              // RIGHT PANEL: Details
                              Expanded(
                                flex: 6,
                                child: _selectedCustomer == null
                                    ? const Center(
                                        child: Text(
                                          "Select a customer to view details",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    : CustomerDetailsContent(
                                        customer: _selectedCustomer!),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildUserInfoHeader(context),
                              const Divider(height: 32),
                              _buildSearchBar(context),
                              const SizedBox(height: 16),
                              if (provider.customers == null ||
                                  provider.customers!.isEmpty)
                                Expanded(child: _buildEmptyState())
                              else
                                Expanded(
                                    child: _buildCustomerList(
                                        context, provider, false)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        });
      }),
    );
  }

  Widget _buildUserInfoHeader(BuildContext context) {
    final userModel =
        Provider.of<AuthenticationProvider>(context, listen: false).user;
    // Handle case where user might be null lightly, though logic suggests it shouldn't be
    if (userModel == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Text(userModel.name?.isNotEmpty == true
                ? userModel.name!.split('').first.toUpperCase()
                : 'U'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.name ?? 'User',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                userModel.email ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Tooltip(
            message: 'Logout',
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthenticationProvider>(context, listen: false);
                await authProvider.logout();
                if (context.mounted) {
                  AppRouter.pushReplace(context, const LoginScreen());
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Customers',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Tooltip(
          message: 'Add New Customer',
          child: FilledButton.icon(
            onPressed: () => _showNewCustomerDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('New Customer'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Customers Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Click "New Customer" to add your first one.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(
      BuildContext context, AuthenticationProvider provider, bool isWide) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    // final appProvider = Provider.of<AppProvider>(context); // Removed if not needed
    // final minPoints = appProvider.gasBalance?.minimumPointForRewards ?? 10;

    return ListView.builder(
      controller: _scrollController,
      // Add one more item for the loading spinner or spacing at the bottom
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
        final points = customer.points ?? 0.0;
        final isEligible = points > 0;
        final isSelected = _selectedCustomer?.id == customer.id;

        // Using a similar style to DataTable but in a ListView for infinite scroll
        return Column(
          children: [
            ListTile(
              selected: isWide && isSelected,
              selectedTileColor: Colors.blue.withOpacity(0.1),
              onTap: () {
                if (isWide) {
                  setState(() {
                    _selectedCustomer = customer;
                  });
                } else {
                  AppRouter.getPage(
                      context, CustomerDetailsScreen(customer: customer));
                }
              },
              leading: CircleAvatar(
                radius: 20,
                backgroundColor:
                    isEligible ? Colors.green[100] : Colors.grey[200],
                // Safely handle null name
                child: Text(customer.name?.isNotEmpty == true
                    ? customer.name!.split('').first.toUpperCase()
                    : '?'),
              ),
              title: Text(customer.name ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Join Date: ${DateFormat('dd MMM yyyy').format(customer.createdAt ?? DateTime.now())}"),
                  if (!isWide &&
                      (points >
                          0)) // Only show bars in list if not wide, to save space? Or stick to existing logic.
                    Row(
                      children: [
                        Icon(Icons.stars, size: 16, color: Colors.amber[800]),
                        const SizedBox(width: 4),
                        Text(currencyFormatter.format(points),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[900])),
                        const SizedBox(width: 8),
                        const Chip(
                          label: Text("Reward",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    ),
                  // Progress bar removed as it's not applicable for open-ended rewards
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currencyFormatter.format(customer.netSpend ?? 0),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  // Provide redeem button in list only if mobile, or both?
                  // If master-detail, redemption is on right.
                  // But redundancy is fine.
                  if (isEligible) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.redeem, color: Colors.green),
                      tooltip: "Redeem Rewards",
                      onPressed: () => showRedemptionDialog(context, customer),
                    )
                  ]
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}

// --- DIALOG (NOW RESPONSIVE AND WITH BETTER VALIDATION) ---
void _showNewCustomerDialog(BuildContext dialogContext) {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: ConstrainedBox(
              // Constrain the dialog width
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('New Customer',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      _buildInputDialogField(
                        controller: nameController,
                        label: 'Name',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      _buildInputDialogField(
                        controller: numberController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Phone number is required'
                            : null,
                      ),
                      const SizedBox(height: 16.0),
                      _buildInputDialogField(
                        controller: emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      _buildInputDialogField(
                        controller: birthdayController,
                        label: 'Date of Birth',
                        readOnly: true,
                        prefixIcon: Icon(Icons.calendar_today_outlined,
                            color: Colors.grey.shade600),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            selectedDate = picked;
                            birthdayController.text =
                                DateFormat('dd MMMM yyyy').format(picked);
                          }
                        },
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              try {
                                await provider.saveCustomer(
                                  CustomerModel(
                                    name: nameController.text.trim(),
                                    phoneNumber: numberController.text.trim(),
                                    netSpend: 0.0,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    dob: selectedDate,
                                  ),
                                );
                                if (!dialogContext.mounted) return;
                                dialogContext.showCustomToast(
                                    message: 'Customer added successfully');
                                Navigator.of(dialogContext).pop();
                              } catch (e) {
                                dialogContext.showCustomToast(
                                    message: e.toString());
                              }
                            }
                          },
                          child: const Text('Create Customer',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildInputDialogField({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
  Widget? prefixIcon,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style:
            TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade700),
      ),
      const SizedBox(height: 8.0),
      TextFormField(
        // Using TextFormField for validation
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
