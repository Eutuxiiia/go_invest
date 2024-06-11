import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category(this.name, this.icon);
}

List<Category> categories = [
  Category('All', Icons.all_inclusive),
  Category('Art', Icons.palette),
  Category('Music', Icons.music_note),
  Category('Crafts', Icons.build),
  Category('Design', Icons.design_services),
  Category('Film and Video', Icons.movie),
  Category('Food', Icons.restaurant),
  Category('Games', Icons.games),
  Category('Technology', Icons.computer),
  Category('Other', Icons.category),
];
