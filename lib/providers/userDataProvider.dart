import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  late Map<String, dynamic> _userData;

  Map<String, dynamic> get userData => _userData;

  UserDataProvider(User? user) {
    if (user != null) {
      fetchUserData(user);
    } else {
      _userData = {};
      notifyListeners(); // Notify listeners even if user is null
    }
  }

  Future<void> fetchUserData(User user) async {
    final userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    _userData = userDataSnapshot.data() ?? {};
    notifyListeners();
  }
}
