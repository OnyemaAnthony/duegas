import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/features/app/setting_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/auth_repo.dart';
import 'package:duegas/features/auth/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     const MyApp(),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<AuthRepository?>(context);
//
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//             create: (_) => AuthenticationProvider(AuthRepository(
//                 firebaseAuth: FirebaseAuth.instance,
//                 firestore: FirebaseFirestore.instance))),
//         StreamProvider<User?>(
//           create: (context) => context.read<AuthRepository>().authStateChanges,
//           initialData: null,
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//             scaffoldBackgroundColor: Colors.white,
//             fontFamily: 'Roboto',
//             primaryColor: Colors.black),
//         home: user == null ? const SignUpScreen() : const DashboardScreen(),
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(
            context.read<AuthRepository>(),
          ),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthRepository>().authStateChanges,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        primaryColor: Colors.black,
      ),
      home: user == null ? const SignUpScreen() : const SettingScreen(),
    );
  }
}
