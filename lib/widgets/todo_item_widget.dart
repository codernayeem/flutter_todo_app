import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class ToDoItemWidget extends StatefulWidget {
  final ToDoItem toDoItem;
  final Function(String, bool) onCheckboxChanged;
  final Function(String) onDelete;

  const ToDoItemWidget({
    super.key,
    required this.toDoItem,
    required this.onCheckboxChanged,
    required this.onDelete,
  });

  @override
  State<ToDoItemWidget> createState() => _ToDoItemWidgetState();
}

class _ToDoItemWidgetState extends State<ToDoItemWidget> {
  void onCheckBoxChange(value) {
    if (value != null) {
      setState(() {
        widget.toDoItem.checked = value;
      });
      widget.onCheckboxChanged(widget.toDoItem.id, value);
    }
  }

  bool dissmis = false;

  @override
  Widget build(BuildContext context) {
    if (dissmis) {
      return const SizedBox();
    } else {
      return Dismissible(
        key: Key(widget.toDoItem.id),
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: const Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Spacer(),
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          setState(() {
            widget.onDelete(widget.toDoItem.id);
            dissmis = true;
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(' dismissed'),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Card(
            elevation: 8.0,
            color: const Color.fromARGB(255, 253, 217, 210),
            child: InkWell(
              onTap: () {},
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Checkbox(
                  value: widget.toDoItem.checked,
                  onChanged: onCheckBoxChange,
                ),
                title: Text(
                  widget.toDoItem.title,
                  style: widget.toDoItem.checked
                      ? const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600)
                      : const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: widget.toDoItem.desc.isNotEmpty
                    ? Text(
                        _truncateDescription(widget.toDoItem.desc),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Column(
                    children: [
                      Text(widget.toDoItem.formattedDate),
                      Text(widget.toDoItem.category.name),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  String _truncateDescription(String description) {
    const int maxDescLength = 50;
    description = description.replaceAll("\n", " | ");
    return description.length <= maxDescLength
        ? description
        : '${description.substring(0, maxDescLength)}...';
  }
}
