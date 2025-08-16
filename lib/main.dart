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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCiE7vB7f7T-NEeotsO42EwaIzbD5DPvnA",
        authDomain: "duenergy-2c177.firebaseapp.com",
        projectId: "duenergy-2c177",
        storageBucket: "duenergy-2c177.firebasestorage.app",
        messagingSenderId: "557671459064",
        appId: "1:557671459064:web:64965d37307b0fa8d6730d",
        measurementId: "G-HS3R0KHF18"),
  );
  // await Firebase.initializeApp();
  trncpy': This function or variable may be unsafe. Consider using strncpy_s instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. See online help for details. [C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\firebase_auth_plugin.vcxproj]
g
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
