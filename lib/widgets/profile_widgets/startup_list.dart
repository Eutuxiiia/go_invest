import 'package:flutter/material.dart';
import 'package:go_invest/providers/userStartupsProvider.dart';
import 'package:go_invest/widgets/search_widgets/startup_widgets_small.dart';
import 'package:provider/provider.dart';

class StartupListWidget extends StatelessWidget {
  const StartupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStartupsProvider>(
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
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Perform deletion action here
                      bool success = await provider.deleteStartup(
                        startups[index]
                            ['uid'], // Assuming id is unique identifier
                      );
                      return success;
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    // This is optional, could be used for UI updates
                    if (direction == DismissDirection.startToEnd) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Startup deleted')),
                      );
                    }
                  },
                  child: StartupWidgetsSmall(startupData: startups[index]),
                ),
              );
            },
          );
        }
      },
    );
  }
}
