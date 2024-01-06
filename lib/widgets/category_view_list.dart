import 'package:flutter/material.dart';
import 'package:flutter_todo_app/providers/category_provider.dart';
import 'package:flutter_todo_app/providers/todo_provider.dart';
import 'package:provider/provider.dart';

import '../models/category_item.dart';
import 'category_view_item.dart';

class CaegoryListView extends StatefulWidget {
  const CaegoryListView({super.key});

  @override
  State<CaegoryListView> createState() => _CaegoryListViewState();
}

class _CaegoryListViewState extends State<CaegoryListView> {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ToDoProvider>(context, listen: false);

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return SizedBox(
          height: 108,
          child: FutureBuilder(
            future: categoryProvider.fetchCategories(todoProvider),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: (!categoryProvider.categoriesLoaded)
                    ? const Placeholder(fallbackHeight: 108)
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.2, 0),
                                  end: const Offset(0, 0),
                                ).animate(animation),
                                child: child),
                          );
                        },
                        child: categoryProvider.categoriesList.isEmpty
                            // ? _emptyListPlaceHolder()
                            ? null
                            : _catsListView(categoryProvider.categoriesList),
                      ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _catsListView(List<CategoryViewItem> categoriesList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoriesList.length,
      itemBuilder: (context, index) {
        return CategoryView(categoriesList[index]);
      },
    );
  }

  // Widget? _emptyListPlaceHolder() {
  //   return Container(
  //     color: Colors.amber,
  //   );
  //   // return const Text("No Cats Yet");
  // }
}
