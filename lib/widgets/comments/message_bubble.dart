import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({super.key, required this.commentMessage});

  final Map<String, dynamic> commentMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timestamp = commentMessage['createdAt'].toDate();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: commentMessage['userImage'] != null
                      ? NetworkImage(commentMessage['userImage']!)
                      : null,
                  child: commentMessage['userImage'] == null
                      ? Icon(Icons.person)
                      : null,
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentMessage['userName'] ?? 'Unknown User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      timestamp.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              commentMessage['text'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
