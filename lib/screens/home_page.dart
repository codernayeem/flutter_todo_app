import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/providers/category_provider.dart';
import 'package:flutter_todo_app/services/auth_services.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/todo_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_view_list.dart';
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

  final todoListKey = GlobalKey<AnimatedListState>();

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
        context.read<ToDoProvider>().reset();
        context.read<CategoryProvider>().reset();
      });
    });
  }

  void loginPage() {
    Navigator.pushNamed(context, 'signUp');
  }

  void addTodoItem(ToDoProvider todoProvider, ToDoItem todo) {
    int indx = todoProvider.addToDoTo(todo);

    if (todoListKey.currentState == null) {
      todoProvider.notify();
      return;
    }

    todoListKey.currentState!
        .insertItem(indx, duration: const Duration(milliseconds: 450));
  }

  void deleteToDoItem(ToDoProvider todoProvider, int index) {
    var todo = todoProvider.todoList[index];
    todoProvider.deleteToDo(todo.id);

    todoListKey.currentState!.removeItem(index, (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInBack),
          ),
          child: ToDoItemWidget(
            toDoItem: todo,
            onDelete: () => null,
            onCheckboxChanged: (_, __) => null,
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 450));
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return _noUserScreen();
    }

    final todoProvider = Provider.of<ToDoProvider>(context, listen: true);
    final catProvider = Provider.of<CategoryProvider>(context, listen: false);

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: AppDrawer(user: _user),
      extendBody: true,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            children: [
              const CaegoryListView(),
              Expanded(
                child: FutureBuilder(
                  future: todoProvider.fetchData(_user!.uid),
                  builder: (context, snapshot) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, .1),
                                end: const Offset(0, 0),
                              ).animate(animation),
                              child: child),
                        );
                      },
                      child: (!todoProvider.itemsLoaded)
                          ? const ShimmerListItem()
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 450),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: todoProvider.todoList.isEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // to make it in center
                                        // categoryItemView's height: 108
                                        _emptyListPlaceHolder(),
                                        const SizedBox(height: 108 + 108 / 2)
                                      ],
                                    )
                                  : _todoListView(todoProvider, catProvider),
                            ),
                    );
                  },
                ),
              ),
            ],
          )),
      bottomNavigationBar: bottomNavBar(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        tooltip: "Create ToDo",
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AddToDoPage(
                onAddToDo: (todo) {
                  addTodoItem(todoProvider, todo);
                  catProvider.addCategory(todo.category);
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

  Widget _todoListView(
      ToDoProvider todoProvider, CategoryProvider catProvider) {
    return AnimatedList(
      key: todoListKey,
      padding: const EdgeInsets.only(bottom: 100),
      initialItemCount: todoProvider.todoList.length,
      itemBuilder: (context, index, animation) {
        ToDoItem todo = todoProvider.todoList[index];
        return SizeTransition(
          sizeFactor: animation,
          child: ToDoItemWidget(
            key: ValueKey(todo.id),
            toDoItem: todo,
            onCheckboxChanged: (id, value) {
              todoProvider.updateCheckBox(id, value);
              catProvider.updateCheckBox(todo.category, value);
            },
            onDelete: () {
              deleteToDoItem(todoProvider, index);
              catProvider.deleteToDoOfCategory(todo.category, todo.checked);
            },
          ),
        );
      },
    );
  }

  Scaffold _noUserScreen() {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: loginPage,
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text("Sign in to Continue"),
          ),
        ),
      ),
    );
  }

  Widget _emptyListPlaceHolder() {
    return const Expanded(
      child: Center(
        child: Text(
          "No ToDo Yet!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 2.0,
      shadowColor: Theme.of(context).colorScheme.shadow,
      title: const Text("My Tasks"),
      actions: [
        Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 18),
            child: _user!.photoURL != null
                ? Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.green,
                                Colors.blue,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _user!.photoURL!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  )
                : null),
      ],
    );
  }

  Widget? bottomNavBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AnimatedBottomNavigationBar.builder(
          height: 64,
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color =
                isActive ? Theme.of(context).colorScheme.primary : Colors.grey;
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
          rightCornerRadius: 8,
          splashRadius: 0,
          elevation: 32,
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
