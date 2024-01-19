import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prac1_app/firebase_options.dart';
import 'dart:developer' show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Log in")),
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: "Enter your email"),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          hintText: "Enter your password"),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/notes/',
                              (route) => false,
                            );
                            
                            log("logged!");
                          } on FirebaseAuthException catch (e) {
                            log(e.code);
                            log(e.message.toString());
                            if (e.code == "user-not-found") {
                              log("user-not-found");
                            } else if (e.code == "wrong-password") {
                              log("wrong-password ops!");
                            }
                          }
                        },
                        child: const Text("Log in")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/register/', (route) => false);
                        },
                        child: const Text('Not registred yet? register here'))
                  ],
                );
              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}
