import 'package:flutter/material.dart';

class ManageScreen extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex {
    return _selectedIndex;
  }

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
