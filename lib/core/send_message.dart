import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SendMessageBox extends StatefulWidget {
  const SendMessageBox({super.key});

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final TextEditingController _textEditingController = TextEditingController();

  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      title: TextField(
        minLines: null,
        textAlignVertical: TextAlignVertical.center,
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          alignLabelWithHint: true,
          hintText: 'Send your love, start typing...',
          hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
              ),
          suffix: SizedBox(
            width: 100,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.blue[100],
              ),
              child: Text(
                "Send!",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () => _sendMessage(),
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        autocorrect: true,
        textCapitalization: TextCapitalization.sentences,
        enableSuggestions: true,
      ),
    );
  }

  void _sendMessage() async {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection("chat")
            .doc(storage.read("chatroom"))
            .update({
          "messages": FieldValue.arrayUnion([
            {
              "text": text,
              "sender": FirebaseAuth.instance.currentUser!.displayName,
              "time": DateTime.now().toUtc(),
            }
          ])
        });
        _textEditingController.clear();
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
