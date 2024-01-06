import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

const categoryIcons = {
  "general": Icons.notes_sharp,
  "food": Icons.lunch_dining_outlined,
  "travel": Icons.flight_takeoff_rounded,
  "leisure": Icons.movie_creation_outlined,
  "work": Icons.work_outline,
  "study": Icons.edit_outlined,
  "others": Icons.other_houses_outlined,
};

class CategoryItem {
  CategoryItem({
    required this.name,
    required this.color,
    this.icon,
  }) : id = uuid.v4();

  String id;
  String name;
  IconData? icon;
  Color? color;

  static CategoryItem defaultCat() {
    return CategoryItem(
        name: "General", icon: categoryIcons["general"], color: Colors.blue);
  }
}

class CategoryViewItem {
  CategoryViewItem({
    required this.category,
    required this.total,
    required this.completed,
  });

  CategoryItem category;
  int total;
  int completed;
}
