import 'package:flutter/material.dart';
import 'package:go_invest/providers/favoritesProvider.dart';
import 'package:go_invest/providers/userDataProvider.dart';
import 'package:go_invest/providers/userProvider.dart';
import 'package:go_invest/providers/userStartupsProvider.dart';
import 'package:go_invest/widgets/profile_widgets/drawer_widget.dart';
import 'package:go_invest/widgets/profile_widgets/favorite_list.dart';
import 'package:go_invest/widgets/profile_widgets/startup_list.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    updateState();
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user is currently logged in.')),
      );
    }

    return FutureBuilder<void>(
      future: Provider.of<UserDataProvider>(context, listen: false)
          .fetchUserData(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userData = Provider.of<UserDataProvider>(context).userData;
          final usernameSurname =
              '${userData['username'] ?? ''} ${userData['surname'] ?? ''}';

          return Scaffold(
            key: _scaffoldKey,
            endDrawer: DrawerWidget(userData: userData, user: user),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const Icon(Icons.abc),
              title: const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(userData['image_url'] ?? ''),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        usernameSurname,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'My projects'),
                    Tab(text: 'Investments'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ChangeNotifierProvider(
                        create: (context) =>
                            UserStartupsProvider()..fetchUserStartups(user.uid),
                        child: StartupListWidget(),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => FavoritesProvider(user.uid)
                          ..fetchFavoriteStartups(),
                        child: FavoriteListWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
