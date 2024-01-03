import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

const categoryIcons = {
  "general": Icons.home,
  "food": Icons.lunch_dining,
  "travel": Icons.flight_takeoff,
  "leisure": Icons.movie,
  "work": Icons.work,
  "study": Icons.edit,
  "others": Icons.other_houses,
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
