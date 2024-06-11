import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/widgets/comments/chat_messages.dart';
import 'package:go_invest/widgets/comments/new_message.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(
      {super.key, required this.user, required this.startupData});

  final User user;
  final Map<String, dynamic> startupData;

  @override
  State<CommentsScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<CommentsScreen> {
  // void setupPushNotifications() async {
  //   final fcm = FirebaseMessaging.instance;

  //   fcm.subscribeToTopic('chat');

  //   // await fcm.requestPermission();
  //   // final token = await fcm.getToken();
  //   // print(token);
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> startupData = widget.startupData;
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(startupData['name'] as String)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.grey[900],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatMessages(
                startupData: startupData,
              ),
            ),
            NewMessage(
              startupData: startupData,
            ),
          ],
        ));
  }
}
