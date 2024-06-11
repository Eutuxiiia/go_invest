import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/providers/favoritesProvider.dart';
import 'package:go_invest/providers/getUserImage.dart';
import 'package:go_invest/providers/startupDetailsProvider.dart';
import 'package:go_invest/providers/userDataProvider.dart';
import 'package:go_invest/providers/userProvider.dart';
import 'package:go_invest/screens/comments_screen.dart';
import 'package:go_invest/widgets/explore_widgets/invest_popup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key, required this.startupData}) : super(key: key);

  final Map<String, dynamic> startupData;

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  bool isFavorite = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    String videoUrl = widget.startupData['video_url'] ?? '';
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await videoPlayerController.initialize();

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

    await initializeFavoriteStatus();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initializeFavoriteStatus() async {
    final favoriteProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    bool startupIsFavorite =
        await favoriteProvider.isFavorite(widget.startupData);
    setState(() {
      isFavorite = startupIsFavorite;
    });
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startupProvider = Provider.of<StartupDetailsProvider>(context);
    final userProvider = Provider.of<GetUserImageProvider>(context);
    final Map<String, dynamic> startupData = widget.startupData;
    final user = Provider.of<UserProvider>(context).user;
    final userData = Provider.of<UserDataProvider>(context).userData;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(startupData['name'] as String)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    user: user!,
                    startupData: startupData,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 200,
                    child: CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerController),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    startupData['name'],
                    style: GoogleFonts.dmSerifDisplay(fontSize: 28),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        FutureBuilder<String>(
                          future: userProvider
                              .getUserImageUrl(startupData['user_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              final userImageUrl = snapshot.data!;
                              return SizedBox(
                                height: 25,
                                width: 25,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(userImageUrl),
                                ),
                              );
                            } else {
                              return const SizedBox(
                                height: 25,
                                width: 25,
                                child: Icon(Icons.error),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 15),
                        Text(startupData['user_name'] ?? 'Unknown'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    startupData['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      height: 2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Invested:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: startupProvider.getInvestments(startupData['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final investments = snapshot.data!;
                        return Column(
                          children: investments.map((investment) {
                            final userImage =
                                investment['userImage'] as String?;
                            final userName = investment['user_name'] as String?;
                            final amount = investment['amount'] as double?;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: userImage != null
                                    ? NetworkImage(userImage)
                                    : const AssetImage(
                                            'assets/default_avatar.png')
                                        as ImageProvider,
                              ),
                              title: Text(userName ?? 'Unknown User'),
                              subtitle: Text('${amount ?? 0}\$ invested'),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No investments yet.');
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 241, 236, 236),
                    ),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    final favoriteProvider =
                        Provider.of<FavoritesProvider>(context, listen: false);
                    if (isFavorite) {
                      await favoriteProvider.addToFavorites(widget.startupData);
                    } else {
                      await favoriteProvider
                          .removeFromFavorites(widget.startupData);
                    }
                  },
                  child: Text(
                    !isFavorite ? 'Add to Favorites' : 'Remove from Favorites',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                FutureBuilder<bool>(
                  future: startupProvider.userHasCard(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey,
                          ),
                        ),
                        child: const Text(
                          'Invest',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      final hasCard = snapshot.data!;
                      final isCreator = startupData['user_id'] == user.uid;
                      final buttonEnabled = hasCard && !isCreator;

                      return ElevatedButton(
                        onPressed: buttonEnabled
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return InvestPopup(
                                      onInvest: (amount, cardNumber,
                                          expiryMonth, expiryYear, cvc) async {
                                        await startupProvider.investInStartup(
                                          userId: user.uid,
                                          userName:
                                              userData['username'] ?? 'User',
                                          userImage: userData['image_url'],
                                          startupId: startupData['uid'],
                                          amount: amount,
                                          cardNumber: cardNumber,
                                          expiryMonth: expiryMonth,
                                          expiryYear: expiryYear,
                                          cvc: cvc,
                                        );
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            buttonEnabled
                                ? const Color.fromARGB(255, 241, 236, 236)
                                : Colors.grey,
                          ),
                        ),
                        child: const Text(
                          'Invest',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
