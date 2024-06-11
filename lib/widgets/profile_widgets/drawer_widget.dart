import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/widgets/profile_widgets/accountScreen.dart';
import 'package:go_invest/widgets/profile_widgets/create_startup.dart';
import 'package:image_picker/image_picker.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key, required this.userData, required this.user});

  final Map<String, dynamic> userData;
  final User user;
  final ImagePicker _picker = ImagePicker();

  void _navigateToCreateStartup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateStartupScreen(user: user, userData: userData),
      ),
    );
  }

  void _navigateToAccountScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountScreen(user: user, userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userData['image_url'] ?? ''),
            ),
            accountEmail: Text('${user.email}'),
            accountName: Text(
              '${userData['username']} ${userData['surname']}',
              style: const TextStyle(fontSize: 24.0),
            ),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 15.0),
            ),
            onTap: () => _navigateToAccountScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text(
              'Create a Startup',
              style: TextStyle(fontSize: 15.0),
            ),
            onTap: () => _navigateToCreateStartup(context),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Log out',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.red,
              ),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
