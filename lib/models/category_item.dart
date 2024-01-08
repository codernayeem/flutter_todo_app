import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

const categoryIcons = {
  "no_icon": null,
  "notes_sharp": Icons.notes_sharp,
  "lunch_dining_outlined": Icons.lunch_dining_outlined,
  "flight_takeoff_rounded": Icons.flight_takeoff_rounded,
  "movie_creation_outlined": Icons.movie_creation_outlined,
  "work_outline": Icons.work_outline,
  "edit_outlined": Icons.edit_outlined,
  "other_houses_outlined": Icons.other_houses_outlined,
  "notification_important_outlined": Icons.notification_important_outlined,
  "note": Icons.note,
  "note_alt_outlined": Icons.note_alt_outlined,
  "not_listed_location_outlined": Icons.not_listed_location_outlined,
  "add_a_photo": Icons.add_a_photo,
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
