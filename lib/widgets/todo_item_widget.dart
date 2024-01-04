import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class ToDoItemWidget extends StatefulWidget {
  final ToDoItem toDoItem;
  final Function(String, bool) onCheckboxChanged;
  final Function() onDelete;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: widget.toDoItem.checked,
            onChanged: onCheckBoxChange,
          ),
          Expanded(
            child: Card(
              elevation: 8.0,
              color: const Color.fromARGB(255, 254, 236, 232),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        title: Text(
                          widget.toDoItem.title,
                          textAlign: TextAlign.justify,
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
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      height: 56,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.toDoItem.formattedDate),
                          Container(
                            child: (widget.toDoItem.category.name == "General")
                                ? null
                                : Chip(
                                    labelStyle: const TextStyle(fontSize: 13),
                                    label: (widget.toDoItem.category.icon !=
                                            null)
                                        ? Row(
                                            children: [
                                              Icon(widget
                                                  .toDoItem.category.icon),
                                              const SizedBox(width: 4.0),
                                              Text(widget
                                                  .toDoItem.category.name),
                                            ],
                                          )
                                        : Text(widget.toDoItem.category.name),
                                    padding: const EdgeInsets.all(0),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 186, 39, 29)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _truncateDescription(String description) {
    const int maxDescLength = 50;
    description = description.replaceAll("\n", " | ");
    return description.length <= maxDescLength
        ? description
        : '${description.substring(0, maxDescLength)}...';
  }
}
