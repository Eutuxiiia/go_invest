import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_invest/widgets/explore_widgets/category_button.dart';
import 'package:go_invest/widgets/explore_widgets/startup_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Map<String, dynamic>>> _startupFuture;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _startupFuture = fetchStartups();
  }

  Future<List<Map<String, dynamic>>> fetchStartups({String? category}) async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('startups');

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    query = query.orderBy('createdAt', descending: true);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

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
            'Explore',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          CategoryButton(
            onSelectCategory: (category) {
              setState(() {
                selectedCategory = category;
                _startupFuture = fetchStartups(category: category);
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _startupFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final startups = snapshot.data!;
                  return ListView.builder(
                    itemCount: startups.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StartupWidget(startupData: startups[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
