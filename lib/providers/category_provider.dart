import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/category_item.dart';
import 'package:flutter_todo_app/providers/todo_provider.dart';

class CategoryProvider with ChangeNotifier {
  final List<CategoryViewItem> _categoriesList = [];
  List<CategoryViewItem> get categoriesList => _categoriesList;

  bool _categoriesLoaded = false;
  bool get categoriesLoaded => _categoriesLoaded;

  Future<void> fetchCategories(ToDoProvider toDoProvider) async {
    if (_categoriesLoaded) return;

    // wait until toDoProvider loads all todos
    await toDoProvider.itemsLoadedCompleter.future;

    _categoriesList.clear();

    for (var element in toDoProvider.todoList) {
      int idx = _categoriesList.indexWhere(
        (cat) {
          return cat.category.name == element.category.name;
        },
      );
      if (idx != -1) {
        _categoriesList[idx].total += 1;
        if (element.checked == true) {
          _categoriesList[idx].completed += 1;
        }
      } else {
        _categoriesList.add(
          CategoryViewItem(
            category: element.category,
            total: 1,
            completed: (element.checked) ? 1 : 0,
          ),
        );
      }
    }

    _categoriesLoaded = true;
  }

  void addCategory(CategoryItem category) {
    int indexCat = findCategoryIndexByName(category.name);
    if (indexCat != -1) {
      _categoriesList[indexCat].total += 1;
    } else {
      _categoriesList.add(CategoryViewItem(
        category: category,
        total: 1,
        completed: 0,
      ));
    }

    notifyListeners();
  }

  int findCategoryIndexByName(String name) {
    return _categoriesList
        .indexWhere((element) => element.category.name == name);
  }

  void updateCheckBox(CategoryItem category, bool value) {
    int indexCat = findCategoryIndexByName(category.name);

    assert(indexCat != -1, "No Category Found for Updating check box status");

    if (indexCat != -1) {
      _categoriesList[indexCat].completed += (value ? 1 : -1);
    }

    notifyListeners();
  }

  void deleteToDoOfCategory(CategoryItem category, bool deletedToDoIsChecked) {
    int indexCat = findCategoryIndexByName(category.name);

    assert(indexCat != 1, "No Category Found for Deleting the todo");

    if (indexCat != -1) {
      _categoriesList[indexCat].total -= 1;
      if (_categoriesList[indexCat].total == 0) {
        _categoriesList.removeAt(indexCat);
      } else if (deletedToDoIsChecked) {
        _categoriesList[indexCat].completed -= 1;
      }
    }

    notifyListeners();
  }

  void reset() {
    _categoriesList.clear();
    _categoriesLoaded = false;
  }
}
