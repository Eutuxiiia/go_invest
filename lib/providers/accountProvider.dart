import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AccountProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage(User user) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      try {
        String fileName = path.basename(file.path);
        Reference storageRef =
            _storage.ref().child('user_avatars/${user.uid}/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);

        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();

        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'image_url': downloadURL});
      } catch (e) {
        print('Error uploading image: $e');
        throw e;
      }
    }
  }

  Future<void> updateUserInfo(User user, String username, String surname,
      String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'username': username,
        'surname': surname,
      });

      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      print('Error updating user info: $e');
      throw e;
    }
  }

  Future<void> saveCardInfo(User user, String cardNumber, String expiryMonth,
      String expiryYear, String cvc) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .add({
        'card_number': cardNumber,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
        'cvc': cvc,
      });
    } catch (e) {
      print('Error saving card info: $e');
      throw e;
    }
  }
}
