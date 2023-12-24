import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ToDoItem> _todoItems = [];
  final TextEditingController _textEditingController = TextEditingController();

  void addToDoItem() {
    String enteredText = _textEditingController.text;
    if (enteredText.isEmpty) return;
    _textEditingController.text = "";
    setState(() {
      _todoItems.insert(0, ToDoItem(data: enteredText, checked: false));
    });
  }

  void deleteToDoItem(int idx) {
    setState(() {
      _todoItems.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("ToDo App"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: _todoItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: _todoItems.length,
                      itemBuilder: (context, index) {
                        return ToDoItemView(
                          task: _todoItems[index],
                          index: index,
                          deletetask: (idx) {
                            deleteToDoItem(idx);
                          },
                          updatetask: (idx) {},
                        );
                      },
                    )
                  : const Center(
                      child: Text("No ToDo Task. Please Add!"),
                    ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          hintText: 'Type something...',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: addToDoItem,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoItemView extends StatefulWidget {
  const ToDoItemView({
    super.key,
    required this.task,
    required this.index,
    required this.deletetask,
    required this.updatetask,
  });

  final ToDoItem task;
  final int index;
  final void Function(dynamic idx) deletetask;
  final void Function(dynamic idx) updatetask;

  @override
  State<ToDoItemView> createState() => _ToDoItemViewState();
}

class _ToDoItemViewState extends State<ToDoItemView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.task.data,
          style: TextStyle(
              decoration: (widget.task.checked)
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        leading: Checkbox(
          onChanged: (bool? value) {
            setState(() {
              widget.task.checked = !widget.task.checked;
            });
            widget.updatetask(widget.index);
          },
          value: widget.task.checked,
        ),
        trailing: IconButton(
            onPressed: () {
              widget.deletetask(widget.index);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
      ),
    );
  }
}
