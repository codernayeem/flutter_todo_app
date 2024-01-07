import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class ToDoDetailsWidget extends StatefulWidget {
  final ToDoItem toDoItem;

  const ToDoDetailsWidget({
    super.key,
    required this.toDoItem,
  });

  @override
  State<ToDoDetailsWidget> createState() => _ToDoItemWDetailstState();
}

class _ToDoItemWDetailstState extends State<ToDoDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final icon = widget.toDoItem.category.getIcon();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Task Title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Spacer(),
              Text(widget.toDoItem.formattedDate),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.toDoItem.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "Category: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                labelStyle: const TextStyle(fontSize: 13),
                label: (icon != null)
                    ? Row(
                        children: [
                          Icon(icon),
                          const SizedBox(width: 4.0),
                          Text(widget.toDoItem.category.name),
                        ],
                      )
                    : Text(widget.toDoItem.category.name),
                padding: const EdgeInsets.all(0),
              ),
            ],
          ),
          Container(
            child: widget.toDoItem.desc.isEmpty
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.toDoItem.desc,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
