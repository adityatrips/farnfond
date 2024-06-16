import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farnfond/core/global_state.dart';
import 'package:farnfond/core/models/app_user.dart';
import 'package:farnfond/core/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatController extends GetxController {
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});

  void updateUserData(Map<String, dynamic> data) {
    userData.value = data;
  }
}

class _ChatScreenState extends State<ChatScreen> {
  AppUser? userData;
  AppUser? partnerData;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final storage = GetStorage();
  final controller = Get.put(GlobalStateController());

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat with your lovely partner!",
          style: Theme.of(context).textTheme.titleMedium!,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .doc(
                  storage.read("chatroom"),
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final messages = snapshot.data!.data()!["messages"];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];

                          return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                margin: FirebaseAuth.instance.currentUser!
                                            .displayName ==
                                        message['sender']
                                    ? const EdgeInsets.only(left: 50)
                                    : const EdgeInsets.only(right: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: FirebaseAuth.instance.currentUser!
                                              .displayName ==
                                          message['sender']
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: FirebaseAuth.instance
                                              .currentUser!.displayName !=
                                          message['sender']
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: FirebaseAuth.instance
                                                  .currentUser!.displayName ==
                                              message['sender']
                                          ? const EdgeInsets.only(right: 20.0)
                                          : const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        message['text'].toString(),
                                        style: TextStyle(
                                          color: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .displayName ==
                                                  message['sender']
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: FirebaseAuth.instance
                                                  .currentUser!.displayName ==
                                              message['sender']
                                          ? const EdgeInsets.only(right: 20.0)
                                          : const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        DateFormat("dd MMM, yyyy hh:mm a")
                                            .format(
                                          (message['time']! as Timestamp)
                                              .toDate(),
                                        ),
                                        style: TextStyle(
                                          color: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .displayName ==
                                                  message['sender']
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )

                              // ListTile(
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(25),
                              //     ),
                              //   ),
                              //   tileColor: Colors.blue[100],
                              // title:
                              // subtitle:
                              // )
                              );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: const SendMessageBox(),
                    ),
                  ],
                );
              }

              // return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
