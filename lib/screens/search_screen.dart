import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/widgets/search_widgets/startup_widgets_small.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  Future<List<Map<String, dynamic>>>? _searchFuture;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  Future<List<Map<String, dynamic>>> fetchStartups(String query) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot;

    querySnapshot = await FirebaseFirestore.instance
        .collection('startups')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            'Search',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    _searchFuture = fetchStartups(value);
                  } else {
                    _searchFuture = null;
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Search for startups',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: _searchFuture == null
                  ? const Center(child: Text('Search for a Startup.'))
                  : FutureBuilder<List<Map<String, dynamic>>>(
                      future: _searchFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final startups = snapshot.data!;
                          if (startups.isEmpty) {
                            return const Center(
                                child: Text('No startups found.'));
                          }
                          return ListView.builder(
                            itemCount: startups.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StartupWidgetsSmall(
                                  startupData: startups[index],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
