import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> _favoritesCollection;

  FavoritesProvider(String userId) {
    // Initialize the collection with the user's UID
    _favoritesCollection =
        _firestore.collection('users').doc(userId).collection('favorites');
  }

  Future<void> addToFavorites(Map<String, dynamic> startupData) async {
    try {
      // Add startup data to favorites with the UID as the document ID
      await _favoritesCollection.doc(startupData['uid']).set(startupData);
      print('added to Favorites');
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeFromFavorites(Map<String, dynamic> startupData) async {
    try {
      await _favoritesCollection.doc(startupData['uid']).delete();
      notifyListeners();
      print('removed to Favorites');
    } catch (error) {
      throw error;
    }
  }

  Future<bool> isFavorite(Map<String, dynamic> startupData) async {
    try {
      final querySnapshot = await _favoritesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        final docIds = querySnapshot.docs.map((doc) => doc.id).toList();
        return docIds.contains(startupData['uid']);
      } else {
        return false; // No documents in the favorites collection
      }
    } catch (error) {
      throw error;
    }
  }

  List<Map<String, dynamic>> _startups = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get startups => _startups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFavoriteStartups() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _favoritesCollection.get();

      _startups = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
