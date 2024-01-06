import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prac1_app/firebase_options.dart';
import 'package:prac1_app/views/email_verify_view.dart';
import 'package:prac1_app/views/login_view.dart';
import 'package:prac1_app/views/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const LoginView(),
      routes: {
        '/login/' : (context) => const LoginView(),
        '/register/' :(context) =>  const RegisterView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome!")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              print(user?.email);
              if (user?.emailVerified ?? false) {
                return const Text("Done");
              } else {
                return const EmailVerifyView();
              }
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}

