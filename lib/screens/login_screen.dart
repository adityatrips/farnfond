import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farnfond/core/global_state.dart';
import 'package:farnfond/screens/home_screen.dart';
import 'package:farnfond/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final globalController = Get.put(GlobalStateController());
  final storage = GetStorage();

  void login() async {
    if (formKey.currentState!.validate()) {
      _login();
    }
  }

  void _login() async {
    await auth
        .signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        )
        .then((value) async {
          final userData = await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.displayName)
              .get();
          storage.writeInMemory("chatroom", userData.data()!["chatroom"]);
          storage.writeInMemory("partnerCode", userData.data()!["partnerCode"]);
          storage.writeInMemory("key", userData.data()!["key"]);
          storage.write("username", email.text);
          storage.write("password", password.text);
          globalController.updateUserData(userData.data()!);
        })
        .then((value) => Get.to(() => const HomeScreen()))
        .catchError(
          (error) {
            Get.snackbar(
              "Error",
              error.toString(),
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );
  }

  @override
  void initState() {
    String? username = storage.read("username");
    String? pword = storage.read("password");

    email.text = username ?? "";
    password.text = pword ?? "";

    // _login();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login!",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              TextFormField(
                autofillHints: const [
                  AutofillHints.email,
                ],
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Enter your email",
                ),
                controller: email,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  } else if (!value.contains("@")) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                autofillHints: const [
                  AutofillHints.password,
                ],
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Enter your password",
                ),
                controller: password,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password!";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.offAll(() => const SignupScreen());
                },
                child: const Text("Don't have an account? Register"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
