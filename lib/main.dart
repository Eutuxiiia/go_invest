import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_invest/providers/accountProvider.dart';
import 'package:go_invest/providers/favoritesProvider.dart';
import 'package:go_invest/providers/getUserImage.dart';
import 'package:go_invest/providers/manageScreens.dart';
import 'package:go_invest/providers/startupDetailsProvider.dart';
import 'package:go_invest/providers/userDataProvider.dart';
import 'package:go_invest/providers/userProvider.dart';
import 'package:go_invest/providers/userStartupsProvider.dart';
import 'package:go_invest/screens/main_screen.dart';
import 'package:go_invest/screens/splash.dart';
import 'package:go_invest/widgets/profile_widgets/authentification_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ManageScreen()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => GetUserImageProvider()),
        ChangeNotifierProvider(create: (context) => UserStartupsProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => StartupDetailsProvider()),
        ChangeNotifierProvider<UserDataProvider>(
          create: (context) {
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return UserDataProvider(user);
            } else {
              return UserDataProvider(null);
            }
          },
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (snapshot.hasData) {
                final User user = snapshot.data!;
                Provider.of<UserProvider>(context, listen: false).setUser(user);
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => FavoritesProvider(user.uid),
                    ),
                  ],
                  child: MainScreen(), // No need to pass the user here
                );
              }
              return const AuthenticationScreen();
            },
          ),
        ),
      ),
    );
  }
}
