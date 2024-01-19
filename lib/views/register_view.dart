import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prac1_app/firebase_options.dart';
import 'dart:developer' show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        appBar: AppBar(title: const Text("Registeration")),
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
                          hintText: "Choose a password"),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            log("registred!");
                          } on FirebaseAuthException catch (e) {
                      
                            if (e.code == "weak-password") {
                              log("weak password, make it STRONGER!");
                            } else if (e.code == "invalid-email") {
                              log("invalid email, double check!!!");
                            } else if (e.code == "email-already-in-use") {
                              log("The email address is already in use by another account");
                            } else {
                              log(e.message.toString());
                            }
                          }
                        },
                        child: const Text("Register")),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/', (route) => false);
                          },
                          child: const Text('Do you have account? login here'))
                  ],
                );
              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}