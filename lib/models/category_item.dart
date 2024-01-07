import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

const categoryIcons = {
  "no_icon": null,
  "notes_sharp": Icons.notes_sharp,
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
    this.icon = "",
  });

  String name;
  String icon;

  static CategoryItem defaultCat() {
    return CategoryItem(name: "General", icon: 'notes_sharp');
  }

  IconData? getIcon() {
    return categoryIcons[icon];
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
