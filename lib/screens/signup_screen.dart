import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farnfond/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final partnerCode = TextEditingController();
  DateTime? birthdate;
  DateTime? anniversary;

  final formKey = GlobalKey<FormState>();

  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  Future<bool> getPermissions() async {
    var locationStatus = await Permission.location.request();
    var locationAlwaysStatus = await Permission.locationAlways.request();
    var ignoreBatteryOptimizations =
        await Permission.ignoreBatteryOptimizations.request();

    if (!locationStatus.isGranted) {
      Get.showSnackbar(
        const GetSnackBar(
          title: "Location Permission Required",
          message: "Please enable location permissions to use the app.",
        ),
      );
    }

    if (!locationAlwaysStatus.isGranted) {
      Get.showSnackbar(
        const GetSnackBar(
          title: "Location Permission Required",
          message: "Please enable location permissions to use the app.",
        ),
      );
    }

    if (!ignoreBatteryOptimizations.isGranted) {
      Get.showSnackbar(
        const GetSnackBar(
          title: "Battery Optimization Permission Required",
          message: "Please disable battery optimization for the app.",
        ),
      );
    }

    return await Permission.location.isGranted &&
        await Permission.locationAlways.isGranted &&
        await Permission.ignoreBatteryOptimizations.isGranted;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = GetStorage();

  void signUp() async {
    String uniqueId = generateRandomString(10);
    String chatroomId = const Uuid().v4();
    if (formKey.currentState!.validate()) {
      if (await getPermissions()) {
        auth
            .createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        )
            .then((createdUser) {
          createdUser.user!.updateDisplayName(uniqueId);
        }).then((value) {
          firestore.collection("users").doc(uniqueId).set({
            "anniversary": anniversary,
            "birthdate": birthdate,
            "email": email.text,
            "key": uniqueId,
            "name": name.text,
            "partnerCode": partnerCode.text,
            "chatroom": chatroomId,
          }).then((value) {
            if (partnerCode.text != "") {
              firestore
                  .collection("users")
                  .doc(partnerCode.text)
                  .get()
                  .then((doc) {
                firestore.collection("users").doc(partnerCode.text).update({
                  "partnerCode": uniqueId,
                  "chatroom": chatroomId,
                });
                firestore.collection("chat").doc(chatroomId).set({
                  "messages": [],
                });
                storage.write("chatroom", chatroomId);
              }).catchError((error) {
                Get.snackbar(
                  "Error",
                  error.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                );
              });
            }
          }).catchError((error) {
            Get.snackbar(
              "Error",
              error.toString(),
              snackPosition: SnackPosition.BOTTOM,
            );
          });
        }).catchError((error) {
          Get.snackbar(
            "Error",
            error.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up!",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Spacer(),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your name",
                ),
                autofillHints: const [AutofillHints.name],
                controller: name,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your email",
                ),
                autofillHints: const [AutofillHints.email],
                controller: email,
                validator: (String? value) {
                  if (!value!.isEmail) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your partner's code",
                ),
                controller: partnerCode,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your password",
                ),
                autofillHints: const [AutofillHints.password],
                controller: password,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your partner's code";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: Get.context!,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((DateTime? value) {
                    setState(() {
                      birthdate = value;
                    });
                  });
                },
                child: Text(
                  birthdate == null
                      ? "Set your birthdate"
                      : "Your birthday is ${birthdate!.toString().split(" ")[0]}",
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: Get.context!,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((DateTime? value) {
                    anniversary = value;
                  });
                },
                child: Text(
                  anniversary == null
                      ? "Set your anniversary"
                      : "Your anniversary is ${anniversary!.toString().split(" ")[0]}",
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: signUp,
                child: const Text("Register"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.offAll(() => const LoginScreen()),
                child: const Text("Already have an account? Login"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
