import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/widgets/comments/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.startupData});

  final Map<String, dynamic> startupData;

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final startupId = startupData['uid'];

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('startups')
          .doc(startupId)
          .collection('messages')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No comments found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final loadedMessages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 5,
            right: 5,
          ),
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            return MessageBubble(
              commentMessage: chatMessage,
            );
          },
        );
      },
    );
  }
}
