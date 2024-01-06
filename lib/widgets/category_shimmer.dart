import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  Widget getContainer(double h, double w, Color c) {
    return Container(
      height: h,
      width: w,
      color: c,
    );
  }

  Widget listItem() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(150, 255, 255, 255),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
          topLeft: Radius.circular(2),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getContainer(18, 50, Colors.white),
          Row(
            children: [
              const Icon(
                Icons.circle,
                size: 30,
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getContainer(28, 60, Colors.white),
              ),
            ],
          ),
          Container(
            height: 10,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : const Color.fromARGB(255, 55, 55, 55),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => listItem(),
      ),
    );
  }
}
