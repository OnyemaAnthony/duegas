import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/customer_model.dart';
import 'package:duegas/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class userProfile extends StatelessWidget {
  const userProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Consumer<AuthenticationProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: Column(
            children: [
              buildUserInfoHeader(context),
              buildSearchBar(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: provider.customers?.length,
                  itemBuilder: (context, index) {
                    return buildCustomerListItem(
                        context, provider.customers![index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget buildUserInfoHeader(BuildContext context) {
  final userModel =
      Provider.of<AuthenticationProvider>(context, listen: false).user;
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(userModel!.name!.split('').first),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel!.name!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              userModel!.email!,
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
                AppRouter.pushReplace(context, const LoginScreen());
              }
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildSearchBar(BuildContext context) {
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
            // Show the dialog onPressed
            onPressed: () {
              _showNewCustomerDialog(context);
            },
          ),
        )
      ],
    ),
  );
}

Widget buildCustomerListItem(BuildContext context, CustomerModel customer) {
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
              child: const Icon(
                Icons.person_outline,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.name!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Since ${DateFormat('dd MMMM yyyy').format(customer.createdAt!)}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₦${customer.netSpend?.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Close
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('New Customer',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)),
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),

                          // Name
                          _buildInputDialogField(
                            controller: nameController,
                            label: 'Name',
                            isRequired: true,
                          ),

                          const SizedBox(height: 16.0),

                          // Number
                          _buildInputDialogField(
                            controller: numberController,
                            label: 'Number',
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 16.0),

                          // Email
                          _buildInputDialogField(
                            controller: emailController,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16.0),

                          // Date of birth
                          _buildInputDialogField(
                            controller: birthdayController,
                            label: 'Date of Birth',
                            readOnly: true,
                            isRequired: true,
                            prefixIcon: Icon(Icons.calendar_today,
                                color: Colors.grey.shade600),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime(2000),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  birthdayController.text =
                                      DateFormat('dd MMMM yyyy').format(picked);
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 32.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  try {
                                    if (nameController.text.isEmpty) {
                                      return dialogContext.showCustomToast(
                                          message: 'Name is required');
                                    }

                                    if (numberController.text.isEmpty) {
                                      return dialogContext.showCustomToast(
                                          message: 'Phone number is required');
                                    }
                                    if (emailController.text.isEmpty) {
                                      return dialogContext.showCustomToast(
                                          message: 'Email is required');
                                    }

                                    if (birthdayController.text.isEmpty) {
                                      return dialogContext.showCustomToast(
                                          message: 'Date of birth is Required');
                                    }
                                    await provider.saveCustomer(
                                      CustomerModel(
                                        name: nameController.text,
                                        phoneNumber: numberController.text,
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
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
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
    },
  );
}

Widget _buildInputDialogField({
  required TextEditingController controller,
  required String label,
  bool isRequired = false,
  TextInputType keyboardType = TextInputType.text,
  Widget? prefixIcon,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey.shade700),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
      const SizedBox(height: 8.0),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    ],
  );
}
