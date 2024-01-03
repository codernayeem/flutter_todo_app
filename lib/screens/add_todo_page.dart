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

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _selectedDate = DateTime.now();
    _focusNode.requestFocus();
    super.initState();
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
      // showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: const Text('Invalid input'),
      //     content: const Text(
      //         'Please make sure a valid title, amount, date and category was entered.'),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.pop(ctx);
      //         },
      //         child: const Text('Okay'),
      //       ),
      //     ],
      //   ),
      // );
      FocusScope.of(context).requestFocus(_focusNode);
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Create \nNew Todo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Poppins',
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
              const Text(
                "Task Title",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
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
              fillColor: const Color.fromARGB(255, 237, 192, 183),
              hintText: 'Title',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 136, 107, 107)),
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
          CategorySelector(
            categories: [
              CategoryItem.defaultCat(),
              CategoryItem(
                  name: 'Food',
                  icon: categoryIcons["food"],
                  color: const Color.fromARGB(255, 236, 185, 169)),
              CategoryItem(
                  name: 'Work',
                  icon: categoryIcons["work"],
                  color: const Color.fromARGB(255, 35, 233, 45)),
              CategoryItem(
                  name: 'Travel',
                  icon: categoryIcons["travel"],
                  color: const Color.fromARGB(255, 27, 243, 160)),
              CategoryItem(
                  name: 'Study',
                  icon: categoryIcons["study"],
                  color: const Color.fromARGB(255, 233, 74, 236)),
              CategoryItem(
                  name: 'Others',
                  icon: categoryIcons["others"],
                  color: const Color.fromARGB(255, 245, 180, 38)),
            ],
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
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
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
                fillColor: const Color.fromARGB(255, 237, 192, 183),
                hintText: 'Description',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 136, 107, 107)),
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
              child: Container(
                width: double.infinity,
                height: 50,
                child: const Center(
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
