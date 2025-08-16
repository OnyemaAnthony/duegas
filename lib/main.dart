import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/app_repository.dart';
import 'package:duegas/features/app/screens/navigation_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/auth_repo.dart';
import 'package:duegas/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: "YOUR_API_KEY",
  //     appId: "YOUR_APP_ID",
  //     messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  //     projectId: "YOUR_PROJECT_ID",
  //     authDomain: "YOUR_AUTH_DOMAIN",
  //     storageBucket: "YOUR_STORAGE_BUCKET",
  //   ),
  // );
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
        ChangeNotifierProvider(
          create: (context) => AppProvider(
            repository: AppRepository(firestore: FirebaseFirestore.instance),
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
      home: user == null ? const LoginScreen() : const NavigationScreen(),
    );
  }
}
