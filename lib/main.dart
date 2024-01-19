import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prac1_app/firebase_options.dart';
import 'package:prac1_app/views/email_verify_view.dart';
import 'package:prac1_app/views/login_view.dart';
import 'package:prac1_app/views/notes_view.dart';
import 'package:prac1_app/views/register_view.dart';
import 'dart:developer' show log;

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
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/email-verify/': (context) => const EmailVerifyView(),
        '/notes/' : (context) => const NotesView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              log('${user?.email}');
              if (user != null) {
                if (user.emailVerified) {
                  return const NotesView();
                } else {
                  return const EmailVerifyView();
                }
              }
              return const LoginView();

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
