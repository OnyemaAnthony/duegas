// import 'package:duegas/core/extensions/toast_message.dart';
// import 'package:duegas/core/utils/app_router.dart';
// import 'package:duegas/features/auth/auth_provider.dart';
// import 'package:duegas/features/auth/model/customer_model.dart';
// import 'package:duegas/features/auth/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class userProfile extends StatelessWidget {
//   const userProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           Consumer<AuthenticationProvider>(builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         return SafeArea(
//           child: Column(
//             children: [
//               buildUserInfoHeader(context),
//               buildSearchBar(context),
//               Builder(builder: (context) {
//                 if (provider.customers!.isEmpty) {
//                   return Center(
//                     child: Text('No customers Added'),
//                   );
//                 }
//                 return Container();
//               }),
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   itemCount: provider.customers?.length,
//                   itemBuilder: (context, index) {
//                     return buildCustomerListItem(
//                         context, provider.customers![index]);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// Widget buildUserInfoHeader(BuildContext context) {
//   final userModel =
//       Provider.of<AuthenticationProvider>(context, listen: false).user;
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Row(
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             CircleAvatar(
//               radius: 30,
//               child: Text(userModel!.name!.split('').first),
//             ),
//             Positioned(
//               bottom: -4,
//               right: -4,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white, size: 16),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 12),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               userModel!.name!,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               userModel!.email!,
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.exit_to_app, color: Colors.orange),
//             onPressed: () async {
//               final authProvider =
//                   Provider.of<AuthenticationProvider>(context, listen: false);
//               await authProvider.logout();
//               if (context.mounted) {
//                 AppRouter.pushReplace(context, const LoginScreen());
//               }
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildSearchBar(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search Customers',
//               prefixIcon: const Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.grey[200],
//               contentPadding: const EdgeInsets.symmetric(vertical: 0),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.person_add_alt_1_outlined,
//                 color: Colors.black54),
//             // Show the dialog onPressed
//             onPressed: () {
//               _showNewCustomerDialog(context);
//             },
//           ),
//         )
//       ],
//     ),
//   );
// }
//
// Widget buildCustomerListItem(BuildContext context, CustomerModel customer) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 12.0),
//     child: Row(
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             CircleAvatar(
//               radius: 28,
//               backgroundColor: Colors.grey[300],
//               child: const Icon(
//                 Icons.person_outline,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 16),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               customer.name!,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Since ${DateFormat('dd MMMM yyyy').format(customer.createdAt!)}',
//               style: const TextStyle(fontSize: 13, color: Colors.grey),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               '₦${customer.netSpend?.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             const Text(
//               'Net Spend',
//               style: TextStyle(fontSize: 13, color: Colors.grey),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// void _showNewCustomerDialog(BuildContext dialogContext) {
//   final nameController = TextEditingController();
//   final numberController = TextEditingController();
//   final emailController = TextEditingController();
//   final birthdayController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   DateTime? selectedDate;
//
//   showDialog(
//     context: dialogContext,
//     builder: (BuildContext context) {
//       return Consumer<AuthenticationProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0),
//                 ),
//                 backgroundColor: Colors.transparent,
//                 child: Container(
//                   padding: const EdgeInsets.all(24.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Title & Close
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text('New Customer',
//                                   style: TextStyle(
//                                       fontSize: 24.0,
//                                       fontWeight: FontWeight.bold)),
//                               InkWell(
//                                 onTap: () => Navigator.of(context).pop(),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade300,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(Icons.close,
//                                       color: Colors.black54),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 24.0),
//
//                           // Name
//                           _buildInputDialogField(
//                             controller: nameController,
//                             label: 'Name',
//                             isRequired: true,
//                           ),
//
//                           const SizedBox(height: 16.0),
//
//                           // Number
//                           _buildInputDialogField(
//                             controller: numberController,
//                             label: 'Number',
//                             keyboardType: TextInputType.phone,
//                           ),
//
//                           const SizedBox(height: 16.0),
//
//                           // Email
//                           _buildInputDialogField(
//                             controller: emailController,
//                             label: 'Email',
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//
//                           const SizedBox(height: 16.0),
//
//                           // Date of birth
//                           _buildInputDialogField(
//                             controller: birthdayController,
//                             label: 'Date of Birth',
//                             readOnly: true,
//                             isRequired: true,
//                             prefixIcon: Icon(Icons.calendar_today,
//                                 color: Colors.grey.shade600),
//                             onTap: () async {
//                               final picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: selectedDate ?? DateTime(2000),
//                                 firstDate: DateTime(1900),
//                                 lastDate: DateTime.now(),
//                               );
//                               if (picked != null) {
//                                 setState(() {
//                                   selectedDate = picked;
//                                   birthdayController.text =
//                                       DateFormat('dd MMMM yyyy').format(picked);
//                                 });
//                               }
//                             },
//                           ),
//
//                           const SizedBox(height: 32.0),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.black,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 if (formKey.currentState?.validate() ?? false) {
//                                   try {
//                                     if (nameController.text.isEmpty) {
//                                       return dialogContext.showCustomToast(
//                                           message: 'Name is required');
//                                     }
//
//                                     if (numberController.text.isEmpty) {
//                                       return dialogContext.showCustomToast(
//                                           message: 'Phone number is required');
//                                     }
//                                     if (emailController.text.isEmpty) {
//                                       return dialogContext.showCustomToast(
//                                           message: 'Email is required');
//                                     }
//
//                                     if (birthdayController.text.isEmpty) {
//                                       return dialogContext.showCustomToast(
//                                           message: 'Date of birth is Required');
//                                     }
//                                     await provider.saveCustomer(
//                                       CustomerModel(
//                                         name: nameController.text,
//                                         phoneNumber: numberController.text,
//                                         netSpend: 0.0,
//                                         createdAt: DateTime.now(),
//                                         updatedAt: DateTime.now(),
//                                         dob: selectedDate,
//                                       ),
//                                     );
//                                     if (!dialogContext.mounted) return;
//                                     dialogContext.showCustomToast(
//                                         message: 'Customer added successfully');
//                                     Navigator.of(dialogContext).pop();
//                                   } catch (e) {
//                                     dialogContext.showCustomToast(
//                                         message: e.toString());
//                                   }
//                                 }
//                               },
//                               child: const Text('Create Customer',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }
//
// Widget _buildInputDialogField({
//   required TextEditingController controller,
//   required String label,
//   bool isRequired = false,
//   TextInputType keyboardType = TextInputType.text,
//   Widget? prefixIcon,
//   bool readOnly = false,
//   VoidCallback? onTap,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//                 fontWeight: FontWeight.w500, color: Colors.grey.shade700),
//           ),
//           if (isRequired)
//             const Text(
//               ' *',
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//         ],
//       ),
//       const SizedBox(height: 8.0),
//       TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         readOnly: readOnly,
//         onTap: onTap,
//         decoration: InputDecoration(
//           prefixIcon: prefixIcon,
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//         ),
//       ),
//     ],
//   );
// }

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
      backgroundColor: Colors.grey[100], // A background color for the page
      body:
          Consumer<AuthenticationProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Center and constrain the content for a professional web layout
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      buildUserInfoHeader(context),
                      const Divider(height: 32),
                      buildSearchBar(context),
                      const SizedBox(height: 16),
                      if (provider.customers == null ||
                          provider.customers!.isEmpty)
                        _buildEmptyState()
                      else
                        _buildCustomerDataTable(context, provider.customers!),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// User Info Header remains largely the same, but will look better in the new layout.
Widget buildUserInfoHeader(BuildContext context) {
  final userModel =
      Provider.of<AuthenticationProvider>(context, listen: false).user;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          child: Text(userModel!.name!.split('').first.toUpperCase()),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel.name!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              userModel.email!,
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

// Search bar is also fine, it will just be constrained by the parent.
Widget buildSearchBar(BuildContext context) {
  return Row(
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
      const SizedBox(width: 16),
      Tooltip(
        message: 'Add New Customer',
        child: FilledButton.icon(
          onPressed: () => _showNewCustomerDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('New Customer'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      )
    ],
  );
}

// A more visually appealing empty state for the customer list.
Widget _buildEmptyState() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 48.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Customers Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Click "New Customer" to add your first one.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

// THE MAJOR UPGRADE: Using a DataTable for a professional web look.
Widget _buildCustomerDataTable(
    BuildContext context, List<CustomerModel> customers) {
  final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

  return SizedBox(
    width: double
        .infinity, // Ensures DataTable takes full width of its parent Card
    child: DataTable(
      columnSpacing: 20,
      columns: const [
        DataColumn(
            label: Text('Customer',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Join Date',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Net Spend',
                style: TextStyle(fontWeight: FontWeight.bold)),
            numeric: true),
      ],
      rows: customers.map((customer) {
        return DataRow(
          cells: [
            // Customer Cell
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
            // Join Date Cell
            DataCell(
              Text(DateFormat('dd MMM yyyy').format(customer.createdAt!)),
            ),
            // Net Spend Cell
            DataCell(
              Text(currencyFormatter.format(customer.netSpend ?? 0)),
            ),
          ],
        );
      }).toList(),
    ),
  );
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
