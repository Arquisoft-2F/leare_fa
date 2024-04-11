import 'package:flutter/material.dart';

class CategoryBadge extends StatelessWidget {
  final String? category_name;
  static const Color badgeColor = Color(0xfff5d9ff);
  const CategoryBadge({super.key, required this.category_name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                category_name!,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
