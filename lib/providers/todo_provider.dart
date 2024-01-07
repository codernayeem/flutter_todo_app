import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo_app/models/category_item.dart';

import '../models/todo_item.dart';

class ToDoProvider with ChangeNotifier {
  List<ToDoItem> _todoList = [];
  List<ToDoItem> get todoList => _todoList;

  Completer<void> itemsLoadedCompleter = Completer<void>();

  bool _itemsLoaded = false;
  bool get itemsLoaded => _itemsLoaded;

  CollectionReference todosRef =
      FirebaseFirestore.instance.collection('todo_items');

  String _userId = "";

  Future<void> fetchData(String userId) async {
    if (_itemsLoaded && userId == _userId) return;

    _userId = userId;

    try {
      QuerySnapshot querySnapshot =
          await todosRef.where('user_id', isEqualTo: userId).get();

      _todoList = querySnapshot.docs
          .map(
            (doc) => ToDoItem(
              id: doc.id,
              title: doc["title"],
              checked: doc["checked"],
              date: DateTime.fromMillisecondsSinceEpoch(doc["date"]),
              desc: doc["desc"],
              category: CategoryItem(
                  name: doc['category'], icon: doc['category_icon']),
            ),
          )
          .toList();

      _itemsLoaded = true;
      itemsLoadedCompleter.complete();
    } catch (error) {
      print('Error getting todos: $error');
    }
  }

  int addToDoTo(ToDoItem todo) {
    int insertIndex = 0;
    todo.resetUuid(); // make a new id
    _todoList.insert(insertIndex, todo);

    todosRef.doc(todo.id).set({
      "user_id": _userId,
      "title": todo.title,
      "checked": todo.checked,
      "date": todo.date.millisecondsSinceEpoch,
      "desc": todo.desc,
      "category": todo.category.name,
      "category_icon": todo.category.icon,
    });

    return insertIndex;
  }

  // void updateToDo(String id, ToDoItem todo) {
  //   int index = findIndexById(id);

  //   if (index == -1) return;

  //   _todoList[index] = todo;

  //   todosRef.doc(todo.id).update({
  //     "title": todo.title,
  //     "checked": todo.checked,
  //     "date": todo.date,
  //     "desc": todo.desc,
  //     "category": todo.category,
  //     "category": todo.category.icon,
  //   });
  // }

  int findIndexById(String id) {
    return _todoList.indexWhere((element) => element.id == id);
  }

  void updateCheckBox(String id, bool value) {
    int idx = findIndexById(id);

    assert(idx != -1, "No todo Found for Updating check box status");

    if (idx == -1) return;

    _todoList[idx].checked = value;

    todosRef.doc(_todoList[idx].id).update({
      "checked": value,
    });
  }

  void deleteToDo(String id) {
    int idx = findIndexById(id);

    assert(idx != -1, "No todo Found for Deletion");
    if (idx == -1) return;

    _todoList.removeAt(idx);

    if (todoList.isEmpty) {
      notifyListeners();
    }

    try {
      todosRef.doc(id).delete();
    } catch (e) {
      print("Delete Error : $e");
    }
  }

  void notify() {
    notifyListeners();
  }

  void reset() {
    _todoList.clear();
    _itemsLoaded = false;
    itemsLoadedCompleter = Completer<void>();
    _userId = "";
  }
}
