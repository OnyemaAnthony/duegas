import 'package:duegas/features/app/screens/user_profile.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

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
