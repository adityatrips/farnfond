import 'package:clickable_widget/clickable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farnfond/core/global_state.dart';
import 'package:farnfond/core/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
    void sendMessage() async {
      await firestore.collection("chat").doc(storage.read("chatroom")).update({
        "messages": FieldValue.arrayUnion([
          {
            "text": message.text,
            "sender": FirebaseAuth.instance.currentUser!.displayName,
            "time": DateTime.now().toUtc(),
          }
        ])
      });

      message.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat with your lovely partner!",
          style: Theme.of(context).textTheme.titleMedium!,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Spacer(),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat")
                    .doc(
                      storage.read("chatroom"),
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Loading...');

                  final data = snapshot.data!.data()!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data['messages'].length,
                    itemBuilder: (context, index) {
                      final message = data['messages'][index];
                      bool isMe = message['sender'] ==
                          FirebaseAuth.instance.currentUser!.displayName;
                      return ClickableColumn(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              if (isMe) {
                                return AlertDialog(
                                  title: const Text("Delete Message"),
                                  content: const Text(
                                      "Are you sure you want to delete this message?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        firestore
                                            .collection("chat")
                                            .doc(storage.read("chatroom"))
                                            .update({
                                          "messages": FieldValue.arrayRemove([
                                            {
                                              "text": message['text'],
                                              "sender": message['sender'],
                                              "time": message['time'],
                                            }
                                          ])
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text("Report Message"),
                                  content: const Text(
                                      "Are you sure you want to report this message?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Report"),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        },
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ).copyWith(
                              right: isMe
                                  ? 0
                                  : MediaQuery.of(context).size.width * 0.25,
                              left: isMe
                                  ? MediaQuery.of(context).size.width * 0.25
                                  : 0,
                            ),
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: message['sender'] ==
                                      FirebaseAuth
                                          .instance.currentUser!.displayName
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.tertiary,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                      // ListTile(
                      //   title: Text(message['text']),
                      //   subtitle: Text(message['sender']),
                      // );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  onSubmitted: (value) {
                    sendMessage();
                  },
                  controller: message,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
