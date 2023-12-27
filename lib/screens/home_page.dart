import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/services/auth_services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ToDoItem> _todoItems = [];
  final TextEditingController _textEditingController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  User? _user;

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void loginPage() {
    Navigator.pushNamed(context, 'signUp');
  }

  void addToDoItem() {
    String enteredText = _textEditingController.text;
    if (enteredText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please Write somthing first"),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
      return;
    }
    ;
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
        title: const Center(child: Text("ToDo App")),
        scrolledUnderElevation: 2.0,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: _user == null
            ? [
                IconButton(
                    onPressed: loginPage,
                    icon: const Icon(
                      Icons.login,
                      color: Colors.black,
                    ))
              ]
            : [
                Text(_user?.displayName ?? ""),
                IconButton(
                    onPressed: authClass.handleSignOut,
                    icon: const Icon(
                      Icons.person_2_sharp,
                      color: Colors.black,
                    ))
              ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: _user != null
            ? Column(
                children: [
                  Expanded(
                    child: _todoItems.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
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
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box_outlined,
                                  color: Colors.green[300],
                                  size: 50,
                                ),
                                const SizedBox(height: 5),
                                const Text("Please Add a ToDo Item"),
                              ],
                            ),
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
              )
            : Center(
                child: ElevatedButton(
                    onPressed: loginPage, child: Text("Sign in to Continue"))),
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
