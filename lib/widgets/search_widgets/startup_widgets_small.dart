import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/providers/favoritesProvider.dart';
import 'package:go_invest/providers/getUserImage.dart';
import 'package:go_invest/widgets/explore_widgets/startup_details_screen.dart';
import 'package:provider/provider.dart';

class StartupWidgetsSmall extends StatelessWidget {
  StartupWidgetsSmall({Key? key, required this.startupData}) : super(key: key);

  final Map<String, dynamic> startupData;

  @override
  Widget build(BuildContext context) {
    // Retrieve the user provider
    final userProvider = Provider.of<GetUserImageProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) =>
                    FavoritesProvider(FirebaseAuth.instance.currentUser!.uid),
                child: StartupScreen(startupData: startupData),
              ),
            ),
          );
        },
        child: Card(
          elevation: 10,
          shadowColor: Colors.black54,
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 150,
                  child: Image.network(
                    startupData['image_url'],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        startupData['name'],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        // Use FutureBuilder to get the user image URL
                        FutureBuilder<String>(
                          future: userProvider
                              .getUserImageUrl(startupData['user_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final userImageUrl = snapshot.data!;
                              return SizedBox(
                                height: 25,
                                width: 25,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(userImageUrl),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 15),
                        Text(startupData['user_name']),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
