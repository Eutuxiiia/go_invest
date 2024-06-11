import 'package:flutter/material.dart';
import 'package:go_invest/providers/manageScreens.dart';
import 'package:go_invest/screens/explore_screen.dart';
import 'package:go_invest/screens/profile_screen.dart';
import 'package:go_invest/screens/search_screen.dart';
import 'package:go_invest/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  static final List<Widget> _pages = <Widget>[
    const ExploreScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(Provider.of<ManageScreen>(context).selectedIndex),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
