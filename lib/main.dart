import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prac1_app/firebase_options.dart';
import 'package:prac1_app/views/email_verify_view.dart';
import 'package:prac1_app/views/login_view.dart';
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
        '/email-verify/': (context) => const EmailVerifyView()
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
                  return const MyNotesView();
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

enum HomePageMenuActions { logout }

class MyNotesView extends StatefulWidget {
  const MyNotesView({super.key});

  @override
  State<MyNotesView> createState() => _MyNotesViewState();
}

class _MyNotesViewState extends State<MyNotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Main UI'), actions: [
      PopupMenuButton<HomePageMenuActions>(
        onSelected: (value) async {
          switch (value) {
            case HomePageMenuActions.logout:
              final shouldLogout = await showLogoutDialog(context);
              log(shouldLogout.toString());
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
              }
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem<HomePageMenuActions>(
                value: HomePageMenuActions.logout, child: Text('Log out'))
          ];
        },
      )
    ]));
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Log out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Log out'))
            ]);
      }).then((value) => value ?? false);
}
