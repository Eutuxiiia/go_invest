import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StartupDetailsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> userHasCard(String userId) async {
    var cardsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .get();
    return cardsSnapshot.docs.isNotEmpty;
  }

  Future<void> investInStartup({
    required String userId,
    required String userName,
    required String userImage,
    required String startupId,
    required double amount,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
  }) async {
    await _firestore
        .collection('startups')
        .doc(startupId)
        .collection('investments')
        .add({
      'user_id': userId,
      'user_name': userName,
      'userImage': userImage,
      'amount': amount,
      'card_number': cardNumber,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'cvc': cvc,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getInvestments(String startupId) async {
    try {
      final snapshot = await _firestore
          .collection('startups')
          .doc(startupId)
          .collection('investments')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching investments: $e');
      return [];
    }
  }
}
