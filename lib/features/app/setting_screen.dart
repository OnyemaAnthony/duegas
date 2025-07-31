import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/app/home_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/screens/login_screen.dart';
import 'package:duegas/features/widgets/new_sale_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customer {
  final String name;
  final String joinDate;
  final double netSpend;
  final String? imageUrl;
  final bool hasBirthday;

  Customer({
    required this.name,
    required this.joinDate,
    required this.netSpend,
    this.imageUrl,
    this.hasBirthday = false,
  });
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const SizedBox(),
    const CustomersScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNewSaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NewSaleDialog();
      },
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
        onPressed: () => _showNewSaleDialog(context),
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
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
                onPressed: () => _onItemTapped(0),
              ),
              const SizedBox(width: 40), // The space for the FAB
              IconButton(
                icon: Icon(Icons.person,
                    color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Customer(
      name: 'Another Customer',
      joinDate: 'Since 20/02/2025',
      netSpend: 150.50,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
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
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthenticationProvider>(context, listen: false);
                await authProvider.logout();
                if (context.mounted) {
                  AppRouter.pushReplace(context, LoginScreen());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
