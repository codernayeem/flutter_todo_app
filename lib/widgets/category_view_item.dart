import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/category_item.dart';

class CategoryView extends StatelessWidget {
  const CategoryView(this.cat, {super.key});
  final CategoryViewItem cat;

  @override
  Widget build(BuildContext context) {
    final icon = cat.category.getIcon();

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
          topLeft: Radius.circular(2),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${cat.total} Tasks",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Row(
            children: icon != null
                ? [
                    Icon(icon, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      cat.category.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ]
                : [
                    Text(
                      cat.category.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
          ),
          _buildSlider(context),
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 10,
              width: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              height: 10,
              width: 120.0 * (cat.completed.toDouble() / cat.total.toDouble()),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
        const SizedBox(width: 8),
        Text('${cat.completed}/${cat.total}'),
      ],
    );
  }
}
