import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/extensions/ui_extension.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/app/screens/navigation_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/model/user_model.dart';
import 'package:duegas/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  String sex = '';

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          Consumer<AuthenticationProvider>(builder: (context, provider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                      label: 'Name:',
                      hint: 'John Doe',
                      controller: _nameController),
                  _buildTextField(
                      label: 'Email:',
                      hint: 'johndoe@email.com',
                      controller: _emailController),
                  _buildSexDropdown(),
                  _buildTextField(
                    label: 'Create Password:',
                    controller: _passwordController,
                    isPassword: true,
                    obscureText: _obscurePassword1,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword1 = !_obscurePassword1;
                      });
                    },
                  ),
                  _buildTextField(
                    label: 'Enter Password Again:',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    obscureText: _obscurePassword2,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword2 = !_obscurePassword2;
                      });
                    },
                  ),
                  _buildDateField(),
                  const SizedBox(height: 20),
                  _buildProceedButton(context),
                  const SizedBox(height: 20),
                  _buildLoginLink().onClick(() {
                    AppRouter.getPage(context, const LoginScreen());
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade300),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSexDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender:',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: 'M',
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: <String>['M', 'F', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              sex = newValue!;
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth:',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _dateController,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            hintStyle: TextStyle(color: Colors.grey.shade300),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.grey.shade500),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProceedButton(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_nameController.text.isEmpty) {
            return context.showCustomToast(message: 'Name is required');
          }
          if (_emailController.text.isEmpty) {
            return context.showCustomToast(message: 'Email is required');
          }
          if (sex.isEmpty) {
            return context.showCustomToast(message: 'Gender is required');
          }
          if (_passwordController.text.isEmpty) {
            return context.showCustomToast(message: 'Password is required');
          }

          if (_confirmPasswordController.text != _passwordController.text) {
            return context.showCustomToast(message: 'Passwords does not match');
          }
          if (_dateController.text.isEmpty) {
            return context.showCustomToast(
                message: 'Date of birth is required');
          }
          final authProvider =
              Provider.of<AuthenticationProvider>(context, listen: false);
          try {
            await authProvider.signUp(
              UserModel(
                  email: _emailController.text,
                  password: _passwordController.text,
                  name: _nameController.text,
                  dob: _dateController.text,
                  gender: sex,
                  isAdmin: true),
            );

            if (!ctx.mounted) return;
            ctx.showCustomToast(message: 'User created successfully');
            AppRouter.pushReplace(ctx, NavigationScreen());
          } catch (e) {
            ctx.showCustomToast(message: e.toString());
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text('Sign up', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
