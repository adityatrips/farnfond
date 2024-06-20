import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final partnerCode = TextEditingController();
  DateTime? birthdate;
  DateTime? anniversary;
  bool loading = true;

  final storage = GetStorage();

  Map? user;

  Future<void> getUser() async {
    String key = storage.read("key");

    FirebaseFirestore.instance.collection("users").doc(key).get().then((value) {
      setState(() {
        user = value.data();
        name.text = user!["name"];
        email.text = user!["email"];
        birthdate = user!["birthdate"].toDate();
        anniversary = user!["anniversary"].toDate();
        partnerCode.text = user!["partnerCode"];
      });
    });
  }

  Future<void> updateProfile() async {
    String key = storage.read("key");

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(key)
        .get()
        .then((value) {
      value.reference.update({
        "name": name.text,
        "email": email.text,
        "birthdate": birthdate,
        "anniversary": anniversary,
        "partnerCode": partnerCode.text,
      }).then((value) {
        Get.snackbar(
          "Success",
          "Profile updated",
          snackPosition: SnackPosition.BOTTOM,
        );
      }).catchError((error) {
        Get.snackbar(
          "Error",
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your account"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ).copyWith(
          top: 16,
        ),
        child: ListView(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              onPressed: () {
                showDatePicker(
                  locale: const Locale("en", "IN"),
                  context: Get.context!,
                  firstDate: DateTime(1900),
                  currentDate: birthdate ?? DateTime.now(),
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
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              onPressed: () {
                showDatePicker(
                  locale: const Locale("en", "IN"),
                  context: Get.context!,
                  currentDate: anniversary ?? DateTime.now(),
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
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: partnerCode,
              decoration: const InputDecoration(
                labelText: "Partner code",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: updateProfile,
              child: const Text("Save"),
            ),
          ],
        ),
      )),
    );
  }
}
