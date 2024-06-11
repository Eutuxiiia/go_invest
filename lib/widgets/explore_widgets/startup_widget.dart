import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/models/categories.dart';
import 'package:go_invest/providers/favoritesProvider.dart';
import 'package:go_invest/widgets/explore_widgets/startup_details_screen.dart';
import 'package:provider/provider.dart';

class StartupWidget extends StatefulWidget {
  final Map<String, dynamic> startupData;

  const StartupWidget({Key? key, required this.startupData}) : super(key: key);

  @override
  _StartupWidgetState createState() => _StartupWidgetState();
}

class _StartupWidgetState extends State<StartupWidget> {
  bool isFavorite = false;
  double rating = 0;

  @override
  void initState() {
    super.initState();
    initializeFavoriteStatus();
  }

  void initializeFavoriteStatus() async {
    final favoriteProvider =
        Provider.of<FavoritesProvider>(context, listen: false);

    // Check if the startup data is a favorite
    bool startupIsFavorite =
        await favoriteProvider.isFavorite(widget.startupData);
    setState(() {
      isFavorite = startupIsFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    Category? category = categories.firstWhere(
      (element) => element.name == widget.startupData['category'],
    );

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
                child: StartupScreen(startupData: widget.startupData),
              ),
            ),
          );
        },
        child: Card(
          shadowColor: Colors.black,
          child: SizedBox(
            height: 400,
            child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    widget.startupData['image_url'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      final favoriteProvider = Provider.of<FavoritesProvider>(
                          context,
                          listen: false);
                      if (isFavorite) {
                        await favoriteProvider
                            .addToFavorites(widget.startupData);
                      } else {
                        await favoriteProvider
                            .removeFromFavorites(widget.startupData);
                      }
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 13),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.startupData['name'],
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                              const TextSpan(text: '   '),
                              TextSpan(
                                text: widget.startupData['description'],
                                style: const TextStyle(
                                  fontSize: 23,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(left: 13.0, right: 13),
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 13),
                        child: Row(
                          children: [
                            Icon(category.icon, color: Colors.black),
                            const SizedBox(width: 5),
                            Text(
                              widget.startupData['category'],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
