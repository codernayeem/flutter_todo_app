import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_item.dart';
import '../providers/category_provider.dart';
import '../screens/create_category_page.dart';

class CategorySelector extends StatefulWidget {
  final Function(CategoryItem) onSelect;

  const CategorySelector({super.key, required this.onSelect});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late int selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    selectedCategoryIndex = 0; // Select the first category by default
  }

  void onAddCategoryClick(bool _) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CreateCategoryPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context, listen: true);
    final categories = provider.choiceCategoryItems();

    categories.add(CategoryItem(name: ""));

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(categories.length, (index) {
        final cat = categories[index];

        if (cat.name.isEmpty) {
          return ChoiceChip(
            label: const Icon(Icons.add),
            selected: selectedCategoryIndex == index,
            onSelected: onAddCategoryClick,
          );
        }

        final icon = cat.getIcon();
        return InputChip(
          showCheckmark: false,
          label: (icon != null)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon),
                    const SizedBox(width: 4.0),
                    Text(cat.name),
                  ],
                )
              : Text(cat.name),
          selected: selectedCategoryIndex == index,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                selectedCategoryIndex = index;
              });
              widget.onSelect(categories[index]);
            }
          },
        );
      }),
    );
  }
}
