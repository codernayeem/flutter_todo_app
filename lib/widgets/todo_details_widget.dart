import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class ToDoDetailsWidget extends StatefulWidget {
  final ToDoItem toDoItem;
  final void Function(ToDoItem) onEdit;

  const ToDoDetailsWidget({
    super.key,
    required this.toDoItem,
    required this.onEdit,
  });

  @override
  State<ToDoDetailsWidget> createState() => _ToDoItemWDetailstState();
}

class _ToDoItemWDetailstState extends State<ToDoDetailsWidget> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late DateTime _selectedDate;

  void onEditTitle() {
    _titleController.text = widget.toDoItem.title;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task Title"),
          content: TextField(
            controller: _titleController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Title',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.transparent, // Border color
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                var title = _titleController.text.trim();
                if (title.isNotEmpty && title != widget.toDoItem.title) {
                  setState(() {
                    widget.toDoItem.title = title;
                    widget.onEdit(widget.toDoItem);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onEditDesc() {
    _descController.text = widget.toDoItem.desc;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task Descriptions"),
          content: Expanded(
            child: TextField(
              expands: true,
              controller: _descController,
              keyboardType: TextInputType.multiline,
              minLines: null,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Description',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                var desc = _descController.text.trim();
                if (desc != widget.toDoItem.desc) {
                  setState(() {
                    widget.toDoItem.desc = desc;
                    widget.onEdit(widget.toDoItem);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.toDoItem.category.getIcon();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SelectableText(
                "Task Title",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(widget.toDoItem.formattedDate),
                  IconButton(
                    onPressed: _datePicker,
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.toDoItem.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: onEditTitle, icon: const Icon(Icons.edit))
            ],
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
                padding: const EdgeInsets.all(0),
                label: (icon != null)
                    ? Row(
                        children: [
                          Icon(icon),
                          const SizedBox(width: 4.0),
                          Text(widget.toDoItem.category.name),
                        ],
                      )
                    : Text(widget.toDoItem.category.name),
              ),
            ],
          ),
          Container(
            child: widget.toDoItem.desc.isEmpty
                ? Row(
                    children: [
                      const Text(
                        " No Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                          onPressed: onEditDesc, icon: const Icon(Icons.edit))
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Description :",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                              onPressed: onEditDesc,
                              icon: const Icon(Icons.edit))
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SelectableText(
                          widget.toDoItem.desc,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _datePicker() async {
    _selectedDate = widget.toDoItem.date;
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1001, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        widget.toDoItem.date = pickedDate;
        widget.onEdit(widget.toDoItem);
      });
    }
  }
}
