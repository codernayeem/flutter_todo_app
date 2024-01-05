import 'package:flutter/material.dart';
import '../models/category_item.dart';

class CategorySelector extends StatefulWidget {
  final List<CategoryItem> categories;
  final Function(CategoryItem) onSelect;

  const CategorySelector(
      {super.key, required this.categories, required this.onSelect});

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late int selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    selectedCategoryIndex = 0; // Select the first category by default
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(widget.categories.length, (index) {
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.categories[index].icon),
                const SizedBox(width: 4.0),
                Text(widget.categories[index].name),
              ],
            ),
            selected: selectedCategoryIndex == index,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  selectedCategoryIndex = index;
                });
                widget.onSelect(widget.categories[index]);
              }
            },
            // selectedColor: widget.categories[index].color,
            // selectedColor: const Color.fromARGB(255, 237, 192, 183),
          );
        }),
      ),
    );
  }
}
