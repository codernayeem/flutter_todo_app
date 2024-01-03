import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo_app/models/category_item.dart';

import '../models/todo_item.dart';

class ToDoProvider with ChangeNotifier {
  List<ToDoItem> _todoList = [];

  List<ToDoItem> get todoList => _todoList;

  bool _itemsLoaded = false;
  bool get itemsLoaded => _itemsLoaded;

  CollectionReference todosRef =
      FirebaseFirestore.instance.collection('todo_items');

  String _userId = "";

  Future<void> fetchData(String userId) async {
    if (_itemsLoaded) return;
    _userId = userId;

    try {
      QuerySnapshot querySnapshot =
          await todosRef.where('user_id', isEqualTo: userId).get();

      _todoList = querySnapshot.docs
          .map((doc) => ToDoItem(
                id: doc.id,
                title: doc["title"],
                checked: doc["checked"],
                date: DateTime.fromMillisecondsSinceEpoch(doc["date"]),
                desc: doc["desc"],
                category: CategoryItem(name: doc['category'], color: null),
              ))
          .toList();

      _itemsLoaded = true;
    } catch (error) {
      print('Error getting todos: $error');
    }
  }

  void addToDoTo(ToDoItem todo) {
    todo.resetUuid(); // make a new id
    _todoList.add(todo);

    todosRef.doc(todo.id).set({
      "user_id": _userId,
      "title": todo.title,
      "checked": todo.checked,
      "date": todo.date.millisecondsSinceEpoch,
      "desc": todo.desc,
      "category": todo.category.name,
    });

    notifyListeners();
  }

  void updateToDo(String id, ToDoItem todo) {
    int index = findIndexById(id);

    if (index == -1) return;

    _todoList[index] = todo;

    todosRef.doc(todo.id).update({
      "title": todo.title,
      "checked": todo.checked,
      "date": todo.date,
      "desc": todo.desc,
      "category": todo.category,
    });
  }

  int findIndexById(String id) {
    return _todoList.indexWhere((element) => element.id == id);
  }

  void updateCheckBox(String id, bool value) {
    int index = findIndexById(id);

    if (index == -1) return;

    _todoList[index].checked = value;

    todosRef.doc(_todoList[index].id).update({
      "checked": value,
    });
  }

  void deleteToDo(String id) {
    _todoList.removeWhere((element) => element.id == id);

    if (todoList.isEmpty) {
      notifyListeners();
    }

    try {
      todosRef.doc(id).delete();
    } catch (e) {
      print("Delete Error : $e");
    }
  }
}
