import 'package:flutter/material.dart';
import 'package:go_invest/models/categories.dart';
import 'package:go_invest/widgets/explore_widgets/bottom_sheet.dart';

class CategoryButton extends StatelessWidget {
  final Function(String)? onSelectCategory;

  CategoryButton({Key? key, this.onSelectCategory}) : super(key: key);

  List<Category> _categories = categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Color.fromARGB(255, 241, 236, 236),
          ),
          shadowColor: MaterialStatePropertyAll(Colors.black),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ExploreBottomSheet(
                categories: _categories,
                onSelectCategory: onSelectCategory,
              );
            },
          );
        },
        child: const Text(
          'Choose Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
