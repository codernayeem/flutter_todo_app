import 'package:flutter_todo_app/models/category_item.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

class ToDoItem {
  ToDoItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.checked,
    required this.date,
    required this.category,
  });

  String id;
  String title;
  String desc;
  bool checked;
  DateTime date;
  CategoryItem category;

  String get formattedDate {
    return formatter.format(date);
  }

  void resetUuid() {
    id = uuid.v4();
  }

  void copyFrom(ToDoItem todo) {
    id = todo.id;
    title = todo.title;
    desc = todo.desc;
    checked = todo.checked;
    date = todo.date;
    category = todo.category;
  }
}
