import 'package:flutter/material.dart';
import 'package:go_invest/models/categories.dart';

class ExploreBottomSheet extends StatelessWidget {
  final List<Category> categories;
  final Function(String)? onSelectCategory;

  const ExploreBottomSheet({
    Key? key,
    required this.categories,
    this.onSelectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Adjust the height as needed
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    leading: Icon(category.icon),
                    title: Text(category.name),
                    onTap: () {
                      onSelectCategory?.call(category.name);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
