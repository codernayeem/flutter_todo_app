import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/services/auth_services.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../widgets/list_shimmer.dart';
import '../widgets/todo_item_widget.dart';
import 'add_todo_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  User? _user;

  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  final iconList = <IconData>[
    Icons.home,
    Icons.settings,
  ];
  final navItems = ["Home", "Settings"];

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

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ToDoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Schedules"),
        scrolledUnderElevation: 2.0,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: _user == null
            ? [
                IconButton(
                    onPressed: loginPage,
                    icon: const Icon(
                      Icons.login,
                    ))
              ]
            : [
                Text(_user?.displayName ?? ""),
                IconButton(
                    onPressed: authClass.handleSignOut,
                    icon: const Icon(
                      Icons.person_2_sharp,
                    ))
              ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: _user != null
            ? Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: todoProvider.fetchData(_user!.uid),
                      builder: (context, snapshot) {
                        if (!todoProvider.itemsLoaded) {
                          return const ShimmerListItem();
                        } else {
                          return todoProvider.todoList.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No ToDo Yet!",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: todoProvider.todoList.length,
                                  itemBuilder: (context, index) {
                                    final todo = todoProvider.todoList[index];
                                    return ToDoItemWidget(
                                      toDoItem: todo,
                                      onCheckboxChanged: (id, value) {
                                        todoProvider.updateCheckBox(id, value);
                                      },
                                      onDelete: (id) {
                                        todoProvider.deleteToDo(id);
                                      },
                                    );
                                  },
                                );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : Center(
                child: OutlinedButton(
                    onPressed: loginPage,
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Sign in to Continue"),
                    ))),
      ),
      bottomNavigationBar: bottomNavBar(),
      floatingActionButton: (_user == null)
          ? null
          : FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AddToDoPage(
                      onAddToDo: (data) {
                        todoProvider.addToDoTo(data);
                      },
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void noItemPlaceholder() {}

  Widget? bottomNavBar() {
    return (_user == null)
        ? null
        : Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedBottomNavigationBar.builder(
                height: 64,
                itemCount: iconList.length,
                tabBuilder: (int index, bool isActive) {
                  final color = isActive ? Colors.green : Colors.grey;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconList[index],
                        size: 24,
                        color: color,
                      ),
                      const SizedBox(height: 3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AutoSizeText(
                          navItems[index],
                          maxLines: 1,
                          style: TextStyle(color: color),
                          group: autoSizeGroup,
                        ),
                      )
                    ],
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.background,
                activeIndex: _bottomNavIndex,
                splashSpeedInMilliseconds: 250,
                notchSmoothness: NotchSmoothness.defaultEdge,
                gapLocation: GapLocation.center,
                leftCornerRadius: 8,
                splashRadius: 0,
                rightCornerRadius: 8,
                elevation: 8,
                onTap: (index) => setState(() => _bottomNavIndex = index),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "Create",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
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
          widget.task.title,
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
