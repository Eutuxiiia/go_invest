import 'package:flutter/material.dart';
import 'package:go_invest/providers/manageScreens.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: Provider.of<ManageScreen>(context).selectedIndex,
      onTap: Provider.of<ManageScreen>(context).onItemTapped,
      type: BottomNavigationBarType.fixed,
      enableFeedback: false,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.green,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
