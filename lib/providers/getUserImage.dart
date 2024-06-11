import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserImageProvider extends ChangeNotifier {
  Future<String> getUserImageUrl(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      if (userData.exists) {
        return userData.data()!['image_url'] as String;
      } else {
        return ''; // Return an empty string if user data doesn't exist
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return ''; // Return an empty string in case of error
    }
  }
}
