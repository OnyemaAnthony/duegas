// import 'package:duegas/core/extensions/toast_message.dart';
// import 'package:duegas/core/utils/app_router.dart';
// import 'package:duegas/features/app/screens/navigation_screen.dart';
// import 'package:duegas/features/auth/auth_provider.dart';
// import 'package:duegas/features/auth/screens/sign_up_screen.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isPasswordVisible = false;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
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
//         return SafeArea(
//           child: SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 60),
//                         const Text(
//                           'Login',
//                           style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                         _buildTextField(
//                             controller: _emailController,
//                             label: 'Email:',
//                             hintText: 'Ugo@gmail.com'),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                             controller: _passwordController,
//                             label: 'Create Password:',
//                             isPassword: true,
//                             hintText: '*********'),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const SizedBox(height: 20),
//                         _buildProceedButton(),
//                         const SizedBox(height: 20),
//                         _buildSignUpLink(),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildTextField(
//       {required TextEditingController controller,
//       required String label,
//       bool isPassword = false,
//       required String hintText}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: isPassword && !_isPasswordVisible,
//           decoration: InputDecoration(
//             hintText: hintText,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.black),
//             ),
//             suffixIcon: isPassword
//                 ? IconButton(
//                     icon: Icon(
//                       _isPasswordVisible
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   )
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProceedButton() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black,
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//       ),
//       onPressed: () async {
//         if (_emailController.text.isEmpty) {
//           return context.showCustomToast(message: 'Email is required');
//         }
//         if (_passwordController.text.isEmpty) {
//           return context.showCustomToast(message: 'Password is required');
//         }
//         try {
//           final authProvider =
//               Provider.of<AuthenticationProvider>(context, listen: false);
//           await authProvider.login(
//             email: _emailController.text.trim(),
//             password: _passwordController.text.trim(),
//           );
//           if (!mounted) return;
//           AppRouter.pushReplace(context, NavigationScreen());
//         } catch (e) {
//           context.showCustomToast(message: e.toString());
//         }
//       },
//       child: const Text(
//         'Proceed',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSignUpLink() {
//     return Align(
//       alignment: Alignment.center,
//       child: RichText(
//         text: TextSpan(
//           text: "Don't have an account? ",
//           style: const TextStyle(color: Colors.grey, fontSize: 14),
//           children: <TextSpan>[
//             TextSpan(
//                 text: 'Sign Up',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     AppRouter.getPage(context, SignUpScreen());
//                   }),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:duegas/core/extensions/toast_message.dart';
import 'package:duegas/core/utils/app_router.dart';
import 'package:duegas/features/app/screens/navigation_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/screens/sign_up_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A light grey background color is common for web pages with centered forms.
      backgroundColor: Colors.grey[100],
      body:
          Consumer<AuthenticationProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // The Center widget is key to centering the form on the web page.
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              // Constrains the maximum width of the form for larger screens.
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 32.0),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Takes up minimum vertical space
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome back! Please enter your details.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                          controller: _emailController,
                          label: 'Email:',
                          hintText: 'Ugo@gmail.com'),
                      const SizedBox(height: 20),
                      _buildTextField(
                          controller: _passwordController,
                          label: 'Password:', // Changed from "Create Password"
                          isPassword: true,
                          hintText: '*********'),
                      const SizedBox(height: 40),
                      _buildProceedButton(),
                      const SizedBox(height: 24),
                      _buildSignUpLink(),
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

  // No changes needed in the helper methods below, they are well-built!

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      bool isPassword = false,
      required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () async {
        if (_emailController.text.isEmpty) {
          return context.showCustomToast(message: 'Email is required');
        }
        if (_passwordController.text.isEmpty) {
          return context.showCustomToast(message: 'Password is required');
        }
        try {
          final authProvider =
              Provider.of<AuthenticationProvider>(context, listen: false);
          await authProvider.login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          if (!mounted) return;
          AppRouter.pushReplace(context, const NavigationScreen());
        } catch (e) {
          context.showCustomToast(message: e.toString());
        }
      },
      child: const Text(
        'Proceed',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(color: Colors.grey, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
                text: 'Sign Up',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppRouter.getPage(context, const SignUpScreen());
                  }),
          ],
        ),
      ),
    );
  }
}
