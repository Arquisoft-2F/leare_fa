import 'package:flutter/material.dart';

import '../../models/models.dart';

class CategoryResult extends StatelessWidget {
  final SearchModel searchResult;
  final void Function()? onTap;
  const CategoryResult({super.key, required this.searchResult, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(searchResult.post.name),
      leading: const Icon(Icons.category, size: 40.0,),
      onTap: onTap,
    );
  }
}