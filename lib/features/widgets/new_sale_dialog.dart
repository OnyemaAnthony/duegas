import 'package:duegas/features/app/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewSaleDialog extends StatefulWidget {
  const NewSaleDialog({super.key});

  @override
  State<NewSaleDialog> createState() => _NewSaleDialogState();
}

class _NewSaleDialogState extends State<NewSaleDialog> {
  final TextEditingController _quantityController =
      TextEditingController(text: '20');
  final TextEditingController _priceController = TextEditingController();
  final double _rate = 2000.0;

  @override
  void initState() {
    super.initState();
    _calculatePrice();
    _quantityController.addListener(_calculatePrice);
  }

  void _calculatePrice() {
    final double? quantity = double.tryParse(_quantityController.text);
    if (quantity != null) {
      final double totalPrice = quantity * _rate;
      final formatter = NumberFormat('#,##0.00', 'en_US');
      _priceController.text = formatter.format(totalPrice);
    } else {
      _priceController.clear();
    }
    setState(() {}); // To update the button text
  }

  String _formatButtonPrice() {
    final double? quantity = double.tryParse(_quantityController.text);
    if (quantity != null) {
      final double totalPrice = quantity * _rate;
      if (totalPrice >= 1000) {
        return '${(totalPrice / 1000).toStringAsFixed(0)}k';
      }
      return totalPrice.toStringAsFixed(0);
    }
    return '0';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 20, top: 45, right: 20, bottom: 20),
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
                _buildTextField(_quantityController, "Quantity (Kg)"),
                const SizedBox(height: 15),
                _buildTextField(_priceController, "Price (₦)", readOnly: true),
                const SizedBox(height: 22),
                _buildProceedButton(),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
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

  Widget _buildProceedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Add proceed logic here
          Navigator.of(context).pop();
        },
        child: RichText(
          text: TextSpan(
            text: 'Proceed ',
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: '(${_formatButtonPrice()})',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// *** END OF NEW WIDGET ***

// The placeholder screen for the "Home" tab
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: const Center(
        child:
            Text('Welcome to the Home Screen!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// The main UI for the Customers screen as shown in the image
class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  // Dummy data for the customer list
  static final List<Customer> _customers = [
    Customer(
      name: 'Mrs Effiong Akpabio',
      joinDate: 'Since 19/01/2025',
      netSpend: 1343.10,
      imageUrl: 'https://i.pravatar.cc/150?img=1', // Placeholder image
    ),
    Customer(
      name: 'Engr Godswill Emmanuel',
      joinDate: 'Since 14/07/2024',
      netSpend: 999.10,
      imageUrl: 'https://i.pravatar.cc/150?img=3', // Placeholder image
    ),
    Customer(
      name: 'Engr Godswill Emmanuel',
      joinDate: 'Since 14/07/2024',
      netSpend: 999.10,
      hasBirthday: true, // This customer has a birthday icon
      imageUrl: 'https://i.pravatar.cc/150?img=3', // Placeholder image
    ),
    Customer(
      name: 'Engr Godswill Emmanuel',
      joinDate: 'Since 14/07/2024',
      netSpend: 999.10,
      imageUrl: 'https://i.pravatar.cc/150?img=3', // Placeholder image
    ),
    Customer(
      name: 'Hyginus Mgbgojikwe',
      joinDate: 'Since 18/01/2025',
      netSpend: 400.10,
      // No imageUrl to show the placeholder icon
    ),
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _UserInfoHeader(),
            const _SearchBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  return _CustomerListItem(customer: _customers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for the top user info section
class _UserInfoHeader extends StatelessWidget {
  const _UserInfoHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=45'), // Placeholder image
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aaron Okafor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'aaronokafor5W@gmail.com',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.orange),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for the search bar
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
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
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined,
                  color: Colors.black54),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

// Widget for a single item in the customer list
class _CustomerListItem extends StatelessWidget {
  final Customer customer;

  const _CustomerListItem({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[300],
                backgroundImage: customer.imageUrl != null
                    ? NetworkImage(customer.imageUrl!)
                    : null,
                child: customer.imageUrl == null
                    ? const Icon(Icons.person_outline,
                        size: 30, color: Colors.grey)
                    : null,
              ),
              if (customer.hasBirthday)
                Positioned(
                  bottom: -5,
                  left: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ]),
                    child: const Icon(Icons.card_giftcard,
                        color: Colors.purple, size: 20),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                customer.joinDate,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${customer.netSpend.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Net Spend',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
