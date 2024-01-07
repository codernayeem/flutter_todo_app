import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/category_item.dart';

import '../models/todo_item.dart';
import '../widgets/category_selector.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key, required this.onAddToDo});

  final void Function(ToDoItem expense) onAddToDo;

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late DateTime _selectedDate;
  CategoryItem _selectedCategory = CategoryItem.defaultCat();

  bool _titleZoomed = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _selectedDate = DateTime.now();
    _focusNode.requestFocus();
    super.initState();
  }

  void _toggleZoom() {
    setState(() {
      _titleZoomed = !_titleZoomed;

      if (_titleZoomed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _titleZoomed = false;
          });
        });
      }
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1001, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitToDoData() {
    if (_titleController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_focusNode);
      _toggleZoom();
      return;
    }

    widget.onAddToDo(
      ToDoItem(
          id: "",
          title: _titleController.text,
          desc: _descController.text,
          date: _selectedDate,
          category: _selectedCategory,
          checked: false),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 48, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Create \nNew Todo",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: _titleZoomed
                    ? TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground,
                      )
                    : TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                curve: Curves.ease,
                child: const Text("Task Title"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formatter.format(_selectedDate)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextField(
            focusNode: _focusNode,
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
          const SizedBox(height: 16),
          const Text(
            "Category",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(height: 8),
          CategorySelector(
            onSelect: (selectedCategory) {
              _selectedCategory = selectedCategory;
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(
            width: double.infinity,
            child: Text(
              "Description (Optional)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
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
          const SizedBox(height: 16),
          FilledButton(
              onPressed: _submitToDoData,
              child: const SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                    child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
