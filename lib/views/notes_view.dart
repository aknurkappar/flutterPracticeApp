
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

enum HomePageMenuActions { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
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
