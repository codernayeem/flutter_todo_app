import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/category_item.dart';
import 'package:flutter_todo_app/providers/category_provider.dart';
import 'package:provider/provider.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  bool _titleZoomed = false;
  final _nameController = TextEditingController();
  int selectedCategoryIconIndex = 0;

  void _submitCategoryData(CategoryProvider provider) {
    var name = _nameController.text.trim();
    if (name.isEmpty) {
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
      return;
    }

    if (provider.addRecentCategory(CategoryItem(
      name: name,
      icon: categoryIcons.keys.elementAt(selectedCategoryIconIndex),
    ))) {
      Navigator.pop(context);
      provider.notify();
    } else {
      print("This category already exits");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 48, right: 16, bottom: 16),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Create \nNew Category",
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
            const SizedBox(height: 16),
            SizedBox(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                textAlign: TextAlign.start,
                style: _titleZoomed
                    ? TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onBackground,
                      )
                    : TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                curve: Curves.ease,
                child: const Text("Category Name"),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Category',
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
            const SizedBox(height: 18),
            const Text(
              "Category Icon",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            getIconList(),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: () => _submitCategoryData(provider),
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
      ),
    );
  }

  Widget getIconList() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(categoryIcons.length, (index) {
        final catIconKey = categoryIcons.keys.elementAt(index);
        final icon = categoryIcons[catIconKey];

        return InputChip(
          label: icon != null ? Icon(icon) : const Text("No icon"),
          showCheckmark: false,
          selected: selectedCategoryIconIndex == index,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                selectedCategoryIconIndex = index;
              });
            }
          },
        );
      }),
    );
  }
}
