import 'package:flutter/material.dart';
import 'package:go_invest/providers/favoritesProvider.dart';
import 'package:go_invest/widgets/search_widgets/startup_widgets_small.dart';
import 'package:provider/provider.dart';

class FavoriteListWidget extends StatelessWidget {
  const FavoriteListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.errorMessage != null) {
          return Center(child: Text('Error: ${provider.errorMessage}'));
        } else {
          final startups = provider.startups;
          return ListView.builder(
            itemCount: startups.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: StartupWidgetsSmall(startupData: startups[index]),
              );
            },
          );
        }
      },
    );
  }
}
