import 'package:duegas/features/app/screens/home_screen.dart';
import 'package:duegas/features/app/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    const SizedBox(),
    const userProfile(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  void showNewSaleDialog(BuildContext context) {
    final TextEditingController quantityController =
        TextEditingController(text: '20');
    final TextEditingController priceController = TextEditingController();
    const double rate = 2000.0;

    void calculatePrice() {
      final double? quantity = double.tryParse(quantityController.text);
      if (quantity != null) {
        final double totalPrice = quantity * rate;
        final formatter = NumberFormat('#,##0.00', 'en_US');
        priceController.text = formatter.format(totalPrice);
      } else {
        priceController.clear();
      }
    }

    String formatButtonPrice() {
      final double? quantity = double.tryParse(quantityController.text);
      if (quantity != null) {
        final double totalPrice = quantity * rate;
        if (totalPrice >= 1000) {
          return '${(totalPrice / 1000).toStringAsFixed(0)}k';
        }
        return totalPrice.toStringAsFixed(0);
      }
      return '0';
    }

    calculatePrice();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            quantityController.addListener(() {
              calculatePrice();
              setState(() {});
            });

            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, top: 45, right: 20, bottom: 20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(Icons.local_gas_station,
                              color: Colors.amber, size: 60),
                          const SizedBox(height: 15),
                          _buildInfoBox(),
                          const SizedBox(height: 20),
                          _buildCustomerChip(),
                          const SizedBox(height: 20),
                          _buildTextField(
                              quantityController, "Quantity (Kg)", false),
                          const SizedBox(height: 15),
                          _buildTextField(priceController, "Price (₦)", true),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Proceed ',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '(${formatButtonPrice()})',
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
                  Positioned(
                    top: 20,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• Current rate is 1Kg of gas to ₦2,000.",
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          SizedBox(height: 4),
          Text("• Go to settings to adjust price",
              style: TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCustomerChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=1'),
              ),
              const SizedBox(width: 8),
              const Text('Mrs Effiong Akpabio',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const Icon(Icons.close, size: 18),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool readOnly) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1,
                height: 24,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showNewSaleDialog(context),
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Sale', style: TextStyle(color: Colors.white)),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home,
                    size: 35,
                    color: _selectedIndex == 0 ? Colors.black : Colors.grey),
                onPressed: () => _onItemTapped(0),
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: Icon(Icons.person,
                    size: 35,
                    color: _selectedIndex == 2 ? Colors.black : Colors.grey),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
