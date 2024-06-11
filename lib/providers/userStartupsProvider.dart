import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserStartupsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _startups = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get startups => _startups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserStartups(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('startups')
              .where('user_id', isEqualTo: userId)
              .get();

      _startups = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteStartup(String startupId) async {
    try {
      await FirebaseFirestore.instance
          .collection('startups')
          .doc(startupId)
          .delete();
      // Optionally, you can also update the local list of startups
      _startups.removeWhere((startup) => startup['uid'] == startupId);
      notifyListeners();
      return true; // Indicate successful deletion
    } catch (error) {
      print('Error deleting startup: $error');
      return false; // Indicate failure in deletion
    }
  }
}
