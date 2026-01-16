import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/utils/after_layout.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/model/sales_model.dart';
import 'package:duegas/features/app/screens/home_screen.dart';
import 'package:duegas/features/app/screens/user_profile.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:duegas/features/auth/screens/customers_screen.dart';
import 'package:duegas/features/auth/screens/sign_up_screen.dart';
import 'package:duegas/features/widgets/printing_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with AfterLayoutMixin<NavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    const UserProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showNewSaleDialog(BuildContext dialogContext) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final double oneKg = appProvider.gasBalance?.priceOfOneKg ?? 0;

    if (oneKg < 1) {
      context.showCustomToast(
          message: "Please set the price of gas in your profile first.");
      return;
    }

    final double rate = oneKg;
    final formKey = GlobalKey<FormState>();

    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    bool _isCalculating = false;

    void _calculatePriceFromQuantity() {
      if (_isCalculating) return;
      _isCalculating = true;

      final quantity = double.tryParse(quantityController.text) ?? 0;
      final totalPrice = quantity * rate;
      priceController.text =
          NumberFormat('#,##0.00', 'en_US').format(totalPrice);

      _isCalculating = false;
    }

    void _calculateQuantityFromPrice() {
      if (_isCalculating) return;
      _isCalculating = true;

      final price =
          double.tryParse(priceController.text.replaceAll(',', '')) ?? 0;
      final quantity = price / rate;
      quantityController.text = quantity.toStringAsFixed(2);

      _isCalculating = false;
    }

    quantityController.addListener(_calculatePriceFromQuantity);
    priceController.addListener(_calculateQuantityFromPrice);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<AppProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            return Container();
          }
          return StatefulBuilder(
            builder: (context, setState) {
              void rebuildListener() => setState(() {});
              quantityController.addListener(rebuildListener);
              priceController.addListener(rebuildListener);

              String formatButtonPrice() {
                final double? price =
                    double.tryParse(priceController.text.replaceAll(',', ''));
                if (price != null) {
                  if (price >= 1000) {
                    return '${(price / 1000).toStringAsFixed(1)}k';
                  }
                  return price.toStringAsFixed(0);
                }
                return '0';
              }

              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("New Sale",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoBox(rate),
                          const SizedBox(height: 20),
                          if (customer.createdAt == null)
                            buildSearchBar(context, () async {
                              CustomerModel? customerModel =
                                  await AppRouter.getPage(
                                      context, const CustomersScreen());
                              if (customerModel != null) {
                                setState(() => customer = customerModel);
                              }
                            })
                          else
                            _buildCustomerChip(() async {
                              CustomerModel? customerModel =
                                  await AppRouter.getPage(
                                      context, const CustomersScreen());
                              if (customerModel != null) {
                                setState(() => customer = customerModel);
                              }
                            }, () {
                              setState(() => customer = CustomerModel());
                            }),
                          const SizedBox(height: 24),
                          _buildSaleTextField(
                            controller: quantityController,
                            label: 'Quantity (Kg)',
                            hint: 'e.g., 5.5',
                          ),
                          const SizedBox(height: 16),
                          _buildSaleTextField(
                            controller: priceController,
                            label: 'Price (₦)',
                            hint: 'e.g., 5000',
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                final quantitySold =
                                    double.tryParse(quantityController.text) ??
                                        0;
                                if (quantitySold <= 0) {
                                  return dialogContext.showCustomToast(
                                      message:
                                          'Please enter a valid quantity or price.');
                                }

                                final remainingBalance =
                                    appProvider.gasBalance?.quantityKg ?? 0;
                                if (quantitySold > remainingBalance) {
                                  return dialogContext.showCustomToast(
                                      message:
                                          'Sale quantity exceeds available gas balance (${remainingBalance.toStringAsFixed(2)} Kg).');
                                }

                                try {
                                  final authProvider =
                                      Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false);
                                  await appProvider.makeSales(
                                    SalesModel(
                                      sellerId: authProvider.user!.id,
                                      sellerName: authProvider.user!.name,
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      customersId: customer.id ?? 'id',
                                      customersName:
                                          customer.name ?? 'Anonymous',
                                      quantityInKg: quantitySold,
                                      priceInNaira: quantitySold * rate,
                                    ),
                                  );
                                  await appProvider.getSales();
                                  if (!dialogContext.mounted) return;
                                  dialogContext.showCustomToast(
                                      message:
                                          'Sale recorded! Earned ${quantitySold.toStringAsFixed(1)} points.');
                                  final service = PrintingService();
                                  final sale = appProvider.sales!.first;

                                  await service.printReceipt(sale);
                                  if (!dialogContext.mounted) return;

                                  Navigator.of(dialogContext).pop();
                                } catch (e) {
                                  dialogContext.showCustomToast(
                                      message: e.toString());
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Proceed ',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '(₦${formatButtonPrice()})',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
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
        });
      },
    ).whenComplete(() {
      quantityController.removeListener(_calculatePriceFromQuantity);
      priceController.removeListener(_calculateQuantityFromPrice);
      quantityController.dispose();
      priceController.dispose();
    });
  }

  Widget _buildSaleTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildInfoBox(double rate) {
    final formattedRate = NumberFormat('#,##0.00', 'en_US').format(rate);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Current Rate: ₦$formattedRate per Kg",
          style: const TextStyle(
              color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  CustomerModel customer = CustomerModel();

  Widget buildSearchBar(BuildContext context, Function() onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: IgnorePointer(
        child: TextField(
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
    );
  }

  Widget _buildCustomerChip(Function() onTap, Function() onXTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    child: Text(customer.name!.split('').first.toUpperCase()),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      customer.name!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onXTap,
            icon: const Icon(Icons.close, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isExtended = constraints.maxWidth > 768;
          return Row(
            children: <Widget>[
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                labelType: isExtended
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                extended: isExtended,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      isExtended
                          ? FilledButton.icon(
                              onPressed: () => showNewSaleDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('New Sale'),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(180, 56),
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            )
                          : IconButton(
                              onPressed: () => showNewSaleDialog(context),
                              icon: const Icon(Icons.add),
                              tooltip: 'New Sale',
                              style: IconButton.styleFrom(
                                minimumSize: const Size(60, 56),
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                      const SizedBox(height: 10),
                      if (isExtended &&
                          (authProvider.user?.isAdmin != null &&
                              authProvider.user!.isAdmin!))
                        OutlinedButton.icon(
                          onPressed: () {
                            AppRouter.getPage(context, SignUpScreen());
                          },
                          icon: const Icon(Icons.person_add_outlined),
                          label: const Text('New Seller'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(180, 56),
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey.shade300),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                    ],
                  ),
                ),
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              // Expanded content remains the same
              Expanded(
                child: Center(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.loadUser();
  }
}
